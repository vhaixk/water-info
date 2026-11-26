import request from "@/utils/request.js";


export const getTreeData = (key) => {

    return request({
        url: `/water/getTreeData`,
        params: {
            mappingName: key
        },
        method: 'get'
    })
}

export const getDicMapping = (key) => {

    return request({
        url: `/water/getDicMapping`,
        params: {
            mappingName: key
        },
        method: 'get'
    })
}

export const getData = (data) => {

    return request({
        url: `/water/getData`,
        data: data,
        method: 'post'
    })
}

export const getProfileData = (path) => {

    return request({
        url: `/water/getProfileData`,
        responseType: 'blob',
        params: {
            profilePath:path
        },
        method: 'get'
    })
}

export const handleExportOrigin = (data) => {

    return request({
        url: `/water/handleExportOrigin`,
        data,
        method: 'post'
    })
}

export const getWaterQualityDic = (dicName) => {

    return request({
        url: `/waterQuality/getWaterQualityDic`,
        params:{dicName},
        method: 'get'
    })
}

export const getWaterQualityData = (data) => {

    return request({
        url: `/waterQuality/getData`,
        data: data,
        method: 'post'
    })
}






export default {
    getTreeData,getDicMapping,getData,getProfileData,handleExportOrigin,getWaterQualityDic,getWaterQualityData
}
