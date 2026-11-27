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

    <el-dialog v-model="wizard.open" :title="wizard.title" width="1000px" align-center draggable append-to-body
               class="ds-wizard-dialog">
      <div class="ds-wizard-body">
        <!-- 左侧步骤导航 -->
        <div class="ds-nav">
          <div v-for="(s, i) in steps" :key="i"
               class="ds-nav-item" :class="{ active: wizard.step === i, done: wizard.maxVisited > i, locked: i > wizard.maxVisited }"
               @click="goStep(i)">
            <span class="ds-nav-index">{{ wizard.maxVisited > i ? '✓' : i + 1 }}</span>
            <span>{{ s }}</span>
          </div>
        </div>
        <!-- 右侧内容区 -->
        <div class="ds-content">
          <!-- 步骤0：基本信息+主表 -->
          <el-form v-show="wizard.step === 0" label-width="80px">
            <el-form-item label="名称" required>
              <el-input v-model="form.dataset_name" :disabled="!!form.dataset_id" placeholder="ds_ 前缀，如 ds_ybt_station_monitor"/>
            </el-form-item>
            <el-form-item label="描述">
              <el-input v-model="form.dataset_comment" placeholder="用途说明，便于列表识别"/>
            </el-form-item>
            <el-form-item label="主表" required>
              <el-select v-model="form.main_table" filterable placeholder="选择已注册表" style="width: 100%" @change="loadAllColumns">
                <el-option v-for="t in regTables" :key="t" :label="t" :value="t"/>
              </el-select>
            </el-form-item>
            <div class="ds-tip">主表决定行级数据权限口径：hy_ 主表自动继承站点授权过滤。</div>
          </el-form>
          <!-- 步骤1：关联表 -->
          <div v-show="wizard.step === 1">
            <div class="ds-toolbar">
              <el-button icon="Plus" plain type="primary" size="small" @click="addJoin">添加关联表</el-button>
              <span class="ds-tip">关联表须已注册；左侧表只能选主表或前序关联表。</span>
            </div>
            <el-card v-for="(j, i) in form.joins" :key="i" shadow="never" class="ds-join-card">
              <div class="ds-join-head">
                <el-select v-model="j.table" filterable placeholder="关联表" style="width: 260px" @change="loadAllColumns">
                  <el-option v-for="t in regTables" :key="t" :label="t" :value="t"/>
                </el-select>
                <el-select v-model="j.joinType" style="width: 100px">
                  <el-option label="LEFT" value="LEFT"/><el-option label="INNER" value="INNER"/>
                </el-select>
                <span class="ds-join-alias">t{{ i + 1 }}</span>
                <el-button link type="danger" @click="form.joins.splice(i, 1)">移除</el-button>
              </div>
              <div class="ds-on-grid ds-on-head">
                <span>左侧表</span><span>左侧列</span><span></span><span>本表列</span><span></span>
              </div>
              <div v-for="(c, k) in j.on" :key="k" class="ds-on-grid">
                <el-select v-model="c.leftTable" filterable placeholder="左侧表">
                  <el-option v-for="t in precedingTables(i)" :key="t" :label="t" :value="t"/>
                </el-select>
                <el-select v-model="c.leftCol" filterable placeholder="左侧列">
                  <el-option v-for="col in colsOf(c.leftTable)" :key="col" :label="col" :value="col"/>
                </el-select>
                <span class="ds-eq">=</span>
                <el-select v-model="c.rightCol" filterable placeholder="本表列">
                  <el-option v-for="col in colsOf(j.table)" :key="col" :label="col" :value="col"/>
                </el-select>
                <el-button link type="danger" icon="Delete" @click="j.on.splice(k, 1)"/>
              </div>
              <el-button link type="primary" size="small" @click="j.on.push({ leftTable: form.main_table, leftCol: '', rightCol: '' })">+ 关联条件</el-button>
            </el-card>
            <el-empty v-if="!form.joins.length" description="无关联表：数据集即主表投影视图" :image-size="60"/>
          </div>
          <!-- 步骤2：输出列 -->
          <div v-show="wizard.step === 2">
            <div class="ds-toolbar">
              <el-input v-model="colSearch" clearable placeholder="搜索列名/别名/注释" style="width: 220px" size="small"/>
              <el-checkbox :model-value="allFilteredChecked" @change="toggleAll">全选当前筛选</el-checkbox>
              <span class="ds-tip">已选 {{ checkedCount }} 列；别名即查询/导出列名。</span>
            </div>
            <el-table :data="filteredCandidates" border max-height="360" size="small">
              <el-table-column width="42" align="center">
                <template #default="s"><el-checkbox v-model="s.row.checked"/></template>
              </el-table-column>
              <el-table-column label="来源" min-width="220" show-overflow-tooltip>
                <template #default="s">{{ s.row.source_table }}.{{ s.row.source_column }}</template>
              </el-table-column>
              <el-table-column label="输出别名" width="160">
                <template #default="s"><el-input v-model="s.row.alias" size="small"/></template>
              </el-table-column>
              <el-table-column label="列注释" min-width="140">
                <template #default="s"><el-input v-model="s.row.column_comment" size="small"/></template>
              </el-table-column>
              <el-table-column label="字典" width="150">
                <template #default="s">
                  <el-select v-model="s.row.dict_type" size="small" filterable clearable allow-create default-first-option placeholder="无">
                    <el-option v-for="d in dictOptions" :key="d.dictType" :label="d.dictName" :value="d.dictType"/>
                  </el-select>
                </template>
              </el-table-column>
            </el-table>
          </div>
          <!-- 步骤3：SQL预览 -->
          <div v-show="wizard.step === 3">
            <div class="ds-toolbar">
              <el-button type="primary" plain size="small" @click="doPreview">生成 SQL 预览</el-button>
              <span class="ds-tip">服务端组装并校验后的只读 SQL，保存后以 ds_ 名称接入查询/导出。</span>
            </div>
            <pre class="ds-sql">{{ wizard.sql || '（点击生成预览）' }}</pre>
          </div>
        </div>
      </div>
      <template #footer>
        <el-button v-if="wizard.step > 0" @click="wizard.step--">上一步</el-button>
        <el-button v-if="wizard.step < 3" type="primary" @click="nextStep">下一步</el-button>
        <el-button v-if="wizard.step === 3" type="primary" @click="submit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { listDataset, getDataset, saveDataset, delDataset, previewSql, tableColumns } from '@/api/tool/dataset'
import { listTable } from '@/api/tool/gen'
import { optionselect as getDictOptionselect } from '@/api/system/dict/type'

const { proxy } = getCurrentInstance()
defineEmits(['preview'])
const query = reactive({ datasetName: '' })
const list = ref([]); const loading = ref(false)
const regTables = ref([])                 // 已注册物理表名
const tableCols = ref({})                 // tableName -> {colName: columnEntity}
const dictOptions = ref([])
const steps = ['主表', '关联表', '输出列', '预览保存']
const wizard = reactive({ open: false, title: '', step: 0, maxVisited: 0, sql: '' })
const form = ref(emptyForm())
const candidates = ref([])
const colSearch = ref('')

const filteredCandidates = computed(() => {
  const kw = colSearch.value.trim().toLowerCase()
  if (!kw) return candidates.value
  return candidates.value.filter(c =>
      (c.source_table + '.' + c.source_column).toLowerCase().includes(kw)
      || (c.alias || '').toLowerCase().includes(kw)
      || (c.column_comment || '').toLowerCase().includes(kw))
})
const checkedCount = computed(() => candidates.value.filter(c => c.checked).length)
const allFilteredChecked = computed(() => filteredCandidates.value.length > 0 && filteredCandidates.value.every(c => c.checked))

function emptyForm() {
  return { dataset_id: null, dataset_name: '', dataset_comment: '', main_table: '', joins: [] }
}
function joinCount(row) {
  try { return JSON.parse(row.join_config || '[]').length } catch { return 0 }
}
function colsOf(t) { return Object.keys(tableCols.value[t] || {}) }
function precedingTables(i) { return [form.value.main_table, ...form.value.joins.slice(0, i).map(j => j.table)].filter(Boolean) }
function goStep(i) { if (i <= wizard.maxVisited) wizard.step = i }
function toggleAll(v) { filteredCandidates.value.forEach(c => { c.checked = !!v }) }

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
  form.value = emptyForm(); candidates.value = []; colSearch.value = ''
  wizard.step = 0; wizard.maxVisited = 0; wizard.sql = ''
  wizard.title = row ? '编辑数据集' : '新建数据集'
  await loadRegTables()
  if (!dictOptions.value.length) {
    const d = await getDictOptionselect()
    dictOptions.value = d.data || []
  }
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
    wizard.maxVisited = 3
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
  wizard.maxVisited = Math.max(wizard.maxVisited, wizard.step)
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

.ds-wizard-body {
  display: flex;
  height: 480px;
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 4px;
  overflow: hidden;
}
.ds-nav {
  width: 148px;
  flex: none;
  border-right: 1px solid var(--el-border-color-lighter);
  background: rgba(255, 255, 255, .04);
  padding: 12px 0;
}
.ds-nav-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  cursor: pointer;
  color: var(--el-text-color-regular);
  &.active {
    color: var(--el-color-primary);
    background: rgba(64, 158, 255, .18);
    border-right: 2px solid var(--el-color-primary);
  }
  &.done .ds-nav-index {
    background: var(--el-color-success);
    color: #fff;
  }
  &.locked {
    cursor: not-allowed;
    opacity: .45;
  }
}
.ds-nav-index {
  width: 20px;
  height: 20px;
  flex: none;
  border-radius: 50%;
  background: rgba(255, 255, 255, .12);
  color: var(--el-text-color-secondary);
  font-size: 12px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
.ds-content {
  flex: 1;
  min-width: 0;
  overflow: auto;
  padding: 16px;
}
.ds-toolbar {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 10px;
}
.ds-tip {
  color: var(--el-text-color-secondary);
  font-size: 12px;
}
.ds-join-card {
  margin-bottom: 10px;
  background: rgba(255, 255, 255, .04);
}
.ds-join-head {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
}
.ds-join-alias {
  color: var(--el-text-color-secondary);
  font-size: 12px;
}
.ds-on-grid {
  display: grid;
  grid-template-columns: 1fr 1fr 20px 1fr 32px;
  gap: 6px;
  align-items: center;
  margin-bottom: 6px;
}
.ds-on-head {
  color: var(--el-text-color-secondary);
  font-size: 12px;
}
.ds-eq {
  text-align: center;
  color: var(--el-text-color-secondary);
}
.ds-sql {
  max-height: 380px;
  overflow: auto;
  background: rgba(0, 0, 0, .3);
  border: 1px solid var(--el-border-color-lighter);
  border-radius: 4px;
  padding: 12px;
  font-size: 12px;
  line-height: 1.7;
  white-space: pre-wrap;
  word-break: break-all;
}
</style>