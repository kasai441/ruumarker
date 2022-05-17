const trimming = (formData, targetModel) => {
  const trimming = formData.get(`${targetModel}[trimming]`)
  if (trimming) {
    return JSON.parse(trimming)
  } else {
    return {x: 0, y: 0}
  }
}

const initFormData = (modelJson, targetModel) => {
  const model = JSON.parse(modelJson)
  const formData = new FormData()
  Object.keys(model).forEach(key => {
    if (model[key]) formData.append(`${targetModel}[${key}]`, model[key])
  })
  return formData
}

const getImageUrl = (imageFile) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => resolve(reader.result)
    reader.onerror = (e) => reject(e)
    reader.readAsDataURL(imageFile)
  })
}

const reduceLargeImage = (imageUrl, imageFile) => {
  return new Promise((resolve, reject) => {
    const maxWidth = 500
    const img = new Image()
    img.onload = () => {
      if (img.width <= maxWidth) return resolve(imageFile)

      const canvas = document.createElement('canvas')
      const height = Math.round(img.height * maxWidth / img.width)
      canvas.width = maxWidth
      canvas.height = height
      let ctx = canvas.getContext('2d')
      ctx.drawImage(img, 0, 0, maxWidth, height)
      ctx.canvas.toBlob((blob) => {
        const f = new File([blob], imageFile.name, {
          type: imageFile.type,
          lastModified: Date.now()
        })
        resolve(f)
      }, imageFile.type, 1)
    }
    img.onerror = (e) => reject(e)
    img.src = imageUrl
  })
}

export default {
  namespaced: true,
  trimming,
  initFormData,
  getImageUrl,
  reduceLargeImage,
}
