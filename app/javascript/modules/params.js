const toPixel = (fieldSize, rate) => {
  return {
    x: fieldSize.w * rate.x,
    y: fieldSize.h * rate.y
  }
}

const parseOrInit = param => {
  if (param) {
    return JSON.parse(param)
  } else {
    return {x: 0, y: 0}
  }
}

const initFormData = (data) => {
  const model = isJson(data) ? JSON.parse(data) : data
  const target = model.target
  const formData = new FormData()
  Object.keys(model).forEach(key => {
    if (model[key]) formData.append(`${target}[${key}]`, model[key])
  })
  formData.append('target', target)
  return formData
}

const renewFormData = (exFormData) => {
  const formData = new FormData()
  for (let entry of exFormData.entries()) {
    formData.append(entry[0], entry[1])
  }
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
    const maxWidth = 800
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

const rotateImage = (imageUrl, imageFile) => {
  if (!imageFile) imageFile = getTypeName(imageUrl)
  return new Promise((resolve, reject) => {
    const img = new Image()
    img.crossOrigin = 'anonymous'
    img.onload = () => {
      const canvas = document.createElement('canvas')
      canvas.width = img.height
      canvas.height = img.width
      let ctx = canvas.getContext('2d')
      ctx.translate(canvas.width / 2, canvas.height / 2)
      ctx.rotate(90 * Math.PI / 180)
      ctx.drawImage(img, -img.width / 2, -img.height / 2, img.width, img.height)
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

const formatDate = str => {
  const d = new Date(str)
  const date = `${d.getFullYear()} ${d.getMonth()+1}/${d.getDate()}`.replace(/\\s/g, '')
  let minutes = String(d.getMinutes())
  if (minutes.length === 1) minutes = `0${minutes}`
  const time = `${d.getHours()}:${minutes}`.replace(/\s/g, '')
  return `${date} ${time}`
}

// private

const getTypeName = imageUrl => {
  const name = imageUrl.split('/').reverse()[0]
  const type = `image/${name.split('.').reverse()[0]}`
  return { name, type }
}

const isJson = data => {
  try {
    JSON.parse(data)
  } catch (error) {
    return false
  }
  return true
}

export default {
  namespaced: true,
  toPixel,
  parseOrInit,
  initFormData,
  renewFormData,
  getImageUrl,
  reduceLargeImage,
  rotateImage,
  formatDate
}
