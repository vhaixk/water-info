import request from '@/utils/request'

// 查询关联数据集列表
export function listDataset(query) {
  return request({ url: '/tool/dataset/list', method: 'get', params: query })
}

// 查询数据集详情（含输出列）
export function getDataset(id) {
  return request({ url: '/tool/dataset/' + id, method: 'get' })
}

// 保存数据集（有 dataset_id 走更新）
export function saveDataset(data) {
  return request({ url: '/tool/dataset', method: data.dataset.dataset_id ? 'put' : 'post', data })
}

// 删除数据集
export function delDataset(ids) {
  return request({ url: '/tool/dataset/' + ids, method: 'delete' })
}

// 预览服务端组装的 SQL
export function previewSql(data) {
  return request({ url: '/tool/dataset/previewSql', method: 'post', data })
}

// 取已注册表的列配置（curd 列元数据，含 column_comment/java_type）
export function tableColumns(tableName) {
  return request({ url: '/curd/' + tableName + '-column', method: 'get' })
}