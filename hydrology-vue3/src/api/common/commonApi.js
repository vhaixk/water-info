import request from '@/utils/request'

export const getColumnConfig = (tableName) => {
    return request({
        url: `/curd/${tableName}-column`,
        method: 'get'
    })
}


export const getColumnData = (tableName, data = {page:1,pageSize:10000}) => {
    if (!data['tableName']) data['tableName'] = tableName;
    return request({
        url: `/curd/${tableName}-query?timestamp=${new Date().getTime()}`,
        data: data,
        method: 'post'
    })
}


export const insertOrUpdate = (tableName, data= {}) => {
    if (!data['tableName']) data['tableName'] = tableName;
    return request({
        url: `/curd/${tableName}-insertOrUpdate`,
        data: data,
        method: 'post'
    })
}


export const removeData = (tableName, data= {}) => {
    if (!data['tableName']) data['tableName'] = tableName;
    return request({
        url: `/curd/${tableName}-delete`,
        data: data,
        method: 'post'
    })
}

export const exportData = (tableName, exportName, data= {}) => {
    if (!data['tableName']) data['tableName'] = tableName;
    return request({
        url: `/curd/${tableName}-export`,
        data: data,
        method: 'post'
    })
}



export function uploadFile(data) {
    return request({
        url: '/common/upload',
        method: 'post',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        data: data
    })
}


export function uploadFiles(data) {
    return request({
        url: '/common/uploads',
        method: 'post',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        data: data
    })
}


export default {
    getColumnConfig,
    getColumnData,
    insertOrUpdate,
    removeData,
    exportData,
    uploadFile,
    uploadFiles
}
