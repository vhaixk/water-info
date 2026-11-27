<template>
  <div class="ds-pane-scroll">
    <el-form :inline="true">
      <el-form-item label="名称">
        <el-input v-model="query.datasetName" clearable style="width: 180px" @keyup.enter="getList"/>
      </el-form-item>
      <el-form-item>
        <el-button icon="Search" type="primary" @click="getList">搜索</el-button>
        <el-button v-hasPermi="['tool:gen:edit']" icon="Plus" type="primary" plain @click="openWizard()">新建数据集</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="list" border stripe>
      <el-table-column label="名称" prop="dataset_name"/>
      <el-table-column label="描述" prop="dataset_comment"/>
      <el-table-column label="主表" prop="main_table"/>
      <el-table-column label="关联表数" width="90">
        <template #default="s">{{ joinCount(s.row) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="220" align="center">
        <template #default="s">
          <el-button link type="primary" @click="$emit('preview', s.row.dataset_name, s.row.dataset_comment)">预览数据</el-button>
          <el-button v-hasPermi="['tool:gen:edit']" link type="primary" @click="openWizard(s.row)">编辑</el-button>
          <el-button v-hasPermi="['tool:gen:remove']" link type="danger" @click="handleDelete(s.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="wizard.open" :title="wizard.title" width="80%" align-center draggable append-to-body>
      <el-steps :active="wizard.step" finish-status="success" simple>
        <el-step title="主表"/><el-step title="关联表"/><el-step title="输出列"/><el-step title="预览保存"/>
      </el-steps>
      <!-- 步骤0：基本信息+主表 -->
      <el-form v-show="wizard.step===0" label-width="90px" style="margin-top:16px">
        <el-form-item label="名称" required>
          <el-input v-model="form.dataset_name" :disabled="!!form.dataset_id" placeholder="ds_ 前缀，如 ds_ybt_station_monitor" style="width:320px"/>
        </el-form-item>
        <el-form-item label="描述"><el-input v-model="form.dataset_comment" style="width:320px"/></el-form-item>
        <el-form-item label="主表" required>
          <el-select v-model="form.main_table" filterable style="width:320px" @change="loadAllColumns">
            <el-option v-for="t in regTables" :key="t" :label="t" :value="t"/>
          </el-select>
        </el-form-item>
      </el-form>
      <!-- 步骤1：关联表（可任意多个） -->
      <div v-show="wizard.step===1" style="margin-top:16px">
        <el-button icon="Plus" plain type="primary" @click="addJoin">添加关联表</el-button>
        <el-card v-for="(j,i) in form.joins" :key="i" style="margin-top:10px">
          <el-form :inline="true">
            <el-form-item label="表">
              <el-select v-model="j.table" filterable style="width:240px" @change="loadAllColumns">
                <el-option v-for="t in regTables" :key="t" :label="t" :value="t"/>
              </el-select>
            </el-form-item>
            <el-form-item label="类型">
              <el-select v-model="j.joinType" style="width:100px">
                <el-option label="LEFT" value="LEFT"/><el-option label="INNER" value="INNER"/>
              </el-select>
            </el-form-item>
            <el-form-item><el-button link type="danger" @click="form.joins.splice(i,1)">移除</el-button></el-form-item>
          </el-form>
          <div v-for="(c,k) in j.on" :key="k" style="margin:6px 0">
            <el-select v-model="c.leftTable" placeholder="左侧表" style="width:220px">
              <el-option v-for="t in precedingTables(i)" :key="t" :label="t" :value="t"/>
            </el-select>
            <el-select v-model="c.leftCol" filterable placeholder="左侧列" style="width:180px;margin:0 6px">
              <el-option v-for="col in colsOf(c.leftTable)" :key="col" :label="col" :value="col"/>
            </el-select>
            =
            <el-select v-model="c.rightCol" filterable placeholder="本表列" style="width:180px;margin:0 6px">
              <el-option v-for="col in colsOf(j.table)" :key="col" :label="col" :value="col"/>
            </el-select>
            <el-button link type="danger" @click="j.on.splice(k,1)">删</el-button>
          </div>
          <el-button link type="primary" @click="j.on.push({leftTable: form.main_table, leftCol:'', rightCol:''})">加关联条件</el-button>
        </el-card>
      </div>
      <!-- 步骤2：输出列（勾选+别名+注释+字典） -->
      <el-table v-show="wizard.step===2" :data="candidates" border max-height="420" style="margin-top:16px">
        <el-table-column width="50">
          <template #default="s"><el-checkbox v-model="s.row.checked"/></template>
        </el-table-column>
        <el-table-column label="来源" width="260">
          <template #default="s">{{ s.row.source_table }}.{{ s.row.source_column }}</template>
        </el-table-column>
        <el-table-column label="输出别名" width="180">
          <template #default="s"><el-input v-model="s.row.alias"/></template>
        </el-table-column>
        <el-table-column label="列注释">
          <template #default="s"><el-input v-model="s.row.column_comment"/></template>
        </el-table-column>
        <el-table-column label="字典类型" width="180">
          <template #default="s"><el-input v-model="s.row.dict_type" placeholder="可空"/></template>
        </el-table-column>
      </el-table>
      <!-- 步骤3：SQL预览 -->
      <div v-show="wizard.step===3" style="margin-top:16px">
        <el-button type="primary" plain @click="doPreview">生成SQL预览</el-button>
        <pre style="max-height:300px;overflow:auto;background:var(--el-fill-color-light);padding:12px">{{ wizard.sql }}</pre>
      </div>
      <template #footer>
        <el-button v-if="wizard.step>0" @click="wizard.step--">上一步</el-button>
        <el-button v-if="wizard.step<3" type="primary" @click="nextStep">下一步</el-button>
        <el-button v-if="wizard.step===3" type="primary" @click="submit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { listDataset, getDataset, saveDataset, delDataset, previewSql, tableColumns } from '@/api/tool/dataset'
import { listTable } from '@/api/tool/gen'

const { proxy } = getCurrentInstance()
defineEmits(['preview'])
const query = reactive({ datasetName: '' })
const list = ref([]); const loading = ref(false)
const regTables = ref([])                 // 已注册物理表名
const tableCols = ref({})                 // tableName -> {colName: columnEntity}
const wizard = reactive({ open: false, title: '', step: 0, sql: '' })
const form = ref(emptyForm())
const candidates = ref([])

function emptyForm() {
  return { dataset_id: null, dataset_name: '', dataset_comment: '', main_table: '', joins: [] }
}
function joinCount(row) {
  try { return JSON.parse(row.join_config || '[]').length } catch { return 0 }
}
function colsOf(t) { return Object.keys(tableCols.value[t] || {}) }
function precedingTables(i) { return [form.value.main_table, ...form.value.joins.slice(0, i).map(j => j.table)].filter(Boolean) }

async function getList() {
  loading.value = true
  const res = await listDataset(query)
  list.value = res.rows; loading.value = false
}
async function loadRegTables() {
  const res = await listTable({ pageNum: 1, pageSize: 1000 })
  regTables.value = res.rows.map(r => r.tableName).filter(n => !n.startsWith('ds_'))
}
async function loadAllColumns() {
  const tables = [form.value.main_table, ...form.value.joins.map(j => j.table)].filter(Boolean)
  for (const t of tables) {
    if (!tableCols.value[t]) {
      const res = await tableColumns(t)
      tableCols.value[t] = res.data || {}
    }
  }
  buildCandidates()
}
function buildCandidates() {
  const old = Object.fromEntries(candidates.value.map(c => [c.source_table + '.' + c.source_column, c]))
  const usedAlias = new Set()
  const rows = []
  for (const t of [form.value.main_table, ...form.value.joins.map(j => j.table)].filter(Boolean)) {
    for (const [col, conf] of Object.entries(tableCols.value[t] || {})) {
      const key = t + '.' + col
      let alias = col
      while (usedAlias.has(alias)) alias = t.split('_').pop() + '_' + alias
      usedAlias.add(alias)
      rows.push(old[key] || {
        source_table: t, source_column: col, alias, checked: false,
        column_comment: conf.column_comment || col, dict_type: conf.dict_type || ''
      })
    }
  }
  candidates.value = rows
}
function addJoin() {
  form.value.joins.push({ table: '', joinType: 'LEFT', sort: form.value.joins.length + 1, on: [{ leftTable: form.value.main_table, leftCol: '', rightCol: '' }] })
}
async function openWizard(row) {
  form.value = emptyForm(); candidates.value = []; wizard.step = 0; wizard.sql = ''
  wizard.title = row ? '编辑数据集' : '新建数据集'
  await loadRegTables()
  if (row) {
    const res = await getDataset(row.dataset_id)
    const ds = res.data.dataset
    form.value = { dataset_id: ds.dataset_id, dataset_name: ds.dataset_name, dataset_comment: ds.dataset_comment,
      main_table: ds.main_table, joins: JSON.parse(ds.join_config || '[]') }
    await loadAllColumns()
    for (const c of res.data.columns) {
      const hit = candidates.value.find(x => x.source_table === c.source_table && x.source_column === c.source_column)
      if (hit) Object.assign(hit, { checked: true, alias: c.alias, column_comment: c.column_comment, dict_type: c.dict_type, is_show: c.is_show, is_list: c.is_list })
    }
  }
  wizard.open = true
}
function nextStep() {
  if (wizard.step === 0 && (!form.value.dataset_name || !form.value.main_table)) return proxy.$modal.msgError('请填写名称并选择主表')
  if (wizard.step === 1) {
    for (const j of form.value.joins) {
      if (!j.table || j.on.some(c => !c.leftTable || !c.leftCol || !c.rightCol)) return proxy.$modal.msgError('关联表/关联条件不完整')
    }
    buildCandidates()
  }
  if (wizard.step === 2 && !candidates.value.some(c => c.checked)) return proxy.$modal.msgError('请至少勾选一个输出列')
  wizard.step++
}
function payload() {
  const cols = candidates.value.filter(c => c.checked).map((c, i) => ({
    source_table: c.source_table, source_column: c.source_column, alias: c.alias,
    column_comment: c.column_comment, dict_type: c.dict_type, is_show: c.is_show ?? '1', is_list: c.is_list ?? '1', sort: i + 1
  }))
  return { dataset: { ...form.value, join_config: JSON.stringify(form.value.joins) }, columns: cols }
}
async function doPreview() {
  const res = await previewSql(payload()); wizard.sql = res.data
}
async function submit() {
  await saveDataset(payload())
  proxy.$modal.msgSuccess('保存成功'); wizard.open = false; getList()
}
function handleDelete(row) {
  proxy.$modal.confirm('确认删除数据集 ' + row.dataset_name + '？').then(() => delDataset(row.dataset_id))
    .then(() => { proxy.$modal.msgSuccess('删除成功'); getList() }).catch(() => {})
}
getList()
</script>

<style lang="scss" scoped>
/* 承接全局主题的 pane 满高规则，内容超出时内部滚动 */
.ds-pane-scroll {
  height: 100%;
  overflow: auto;
}
</style>