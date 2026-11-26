import request from "@/utils/request.js";


export const downloadFile = async (url,fileName) => {
    try {
        const res = await request.post(url, {}, {
            responseType: 'blob',
            method: 'post'
        });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(new Blob([res]));
        link.download = fileName || getFullName(url);
        document.body.appendChild(link);
        link.click();
        // 清理资源
        document.body.removeChild(link);
        URL.revokeObjectURL(link.href);
    } catch (error) {
        console.error('下载失败', error);
    }
};

export const getLocation = () => {
    // 获取协议 (http: 或 https:)
    const protocol = window.location.protocol;

    // 获取主机名 (可能是 IP，也可能是域名，如 192.168.1.100 或 localhost)
    const hostname = window.location.hostname;

// 获取端口 (如 :8080, 如果是默认端口可能为空)
    const port = window.location.port;

// 拼接成基础路径
    const baseUrl = `${protocol}//${hostname}${port ? ':' + port : ''}`;
    return baseUrl

}


export const getSuffixName = (filePath) => {
    if (!filePath) return '';
    const fileName = filePath.split('/').pop().split('\\').pop();
    const lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex === -1 || lastDotIndex === 0) return '';
    return fileName.slice(lastDotIndex + 1);
};

export const getFilePrefixName = (filePath) => {
    if (!filePath) return '';
    const fileName = filePath.split('/').pop().split('\\').pop();
    const lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex === -1) return fileName;
    return fileName.slice(0, lastDotIndex);
};

export const getFullName = (filePath) => {
    if (!filePath) return '';
    return filePath.split('/').pop().split('\\').pop();
};


export default {
    downloadFile,
    getFilePrefixName,
    getFullName,
    getSuffixName,
    getLocation,
}
