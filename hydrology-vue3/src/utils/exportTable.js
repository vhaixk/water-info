import * as XLSX from 'xlsx-js-style'
import FileSaver from 'file-saver'

// 样式定义
const borderStyle = {
    top: {style: 'thin', color: {rgb: '000000'}},
    bottom: {style: 'thin', color: {rgb: '000000'}},
    left: {style: 'thin', color: {rgb: '000000'}},
    right: {style: 'thin', color: {rgb: '000000'}}
}

const headerStyle = {
    fill: {fgColor: {rgb: 'F2F2F2'}},        // 灰色背景
    font: {sz: 12, bold: true, color: {rgb: '000000'}},
    alignment: {horizontal: 'center', vertical: 'center'}
}

const contentStyle = {
    alignment: {horizontal: 'left', vertical: 'center'}
}


export const exportTable = (elementId= 'export-table', excelName= "导出数据", headerRowCount= 1) => {
    const tableElement = document.getElementById(elementId)
    if (!tableElement) return

    // 转换为工作簿
    const workbook = XLSX.utils.table_to_book(tableElement, {raw: true})
    const worksheet = workbook.Sheets[workbook.SheetNames[0]]

    const range = XLSX.utils.decode_range(worksheet['!ref'] || 'A1')

    const colWidths= []

    // 遍历所有单元格
    for (let R = range.s.r; R <= range.e.r; ++R) {
        for (let C = range.s.c; C <= range.e.c; ++C) {
            const cellAddress = XLSX.utils.encode_cell({r: R, c: C})

            // 确保单元格存在（解决空单元格无边框问题）
            if (!worksheet[cellAddress]) {
                worksheet[cellAddress] = {t: 's', v: ''}
            }

            const cell = worksheet[cellAddress]
            if (!cell.s) cell.s = {}

            // 强制添加边框（所有单元格都有边框）
            cell.s.border = {...borderStyle}

            // 根据传入的 headerRowCount 判断是否为表头
            const isHeader = R < headerRowCount   // 第 0 ~ headerRowCount-1 行为表头

            if (isHeader) {
                // 应用表头样式（灰色背景 + 加粗 + 居中）
                cell.s.fill = headerStyle.fill
                cell.s.font = headerStyle.font
                cell.s.alignment = headerStyle.alignment
            } else {
                // 数据行只设置左对齐
                cell.s.alignment = contentStyle.alignment
            }

            // 计算列宽（支持中文）
            let cellText = cell.v != null ? String(cell.v) : ''
            const textWidth = cellText.split('').reduce((w, char) => {
                return w + (char.charCodeAt(0) > 255 ? 2 : 1)
            }, 0)

            let wch = Math.max(textWidth + 2, 10)
            if (!colWidths[C] || wch > colWidths[C]) {
                colWidths[C] = wch
            }
        }
    }

    // 应用列宽
    worksheet['!cols'] = colWidths.map(w => ({wch: w}))

    // 导出
    try {
        const wbout = XLSX.write(workbook, {bookType: 'xlsx', type: 'array'})
        FileSaver.saveAs(
            new Blob([wbout], {type: 'application/octet-stream'}),
            excelName+'.xlsx'
        )
    } catch (e) {
        console.error('导出失败:', e)
    }
}
