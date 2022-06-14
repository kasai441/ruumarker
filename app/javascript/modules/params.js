import log from "tailwindcss/lib/util/log"

const toPx = (field, rate) => {
  return {
    x: toF(field.w * rate.x, 1),
    y: toF(field.h * rate.y, 1)
  }
}

const toF = (number, fractionDigits) => {
  return Math.floor(number * 10**fractionDigits) / 10**fractionDigits
}

const fromJson = (formData, targetModel, param) => {
  return parseOrInit(formData.get(`${targetModel}[${param}]`))
}

const parseOrInit = param => {
  if (param) {
    return JSON.parse(param)
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

const rotateImage = (imageUrl, imageFile) => {
  console.log(imageUrl.type)
  console.log(imageUrl.name)
  console.log(imageFile.type)
  console.log(imageFile.name)
  return new Promise((resolve, reject) => {
    const img = new Image()
    img.onload = () => {
      const canvas = document.createElement('canvas')
      console.log(img.width)

      canvas.width = img.width
      canvas.height = img.height
      let ctx = canvas.getContext('2d')
      ctx.save()
      ctx.clearRect(0, 0, canvas.width, canvas.height)
      ctx.translate(canvas.width / 2, canvas.height / 2)
      ctx.rotate(90 * Math.PI / 180)
      ctx.drawImage(img, -canvas.width / 2, -canvas.height / 2, canvas.width, canvas.height)
      ctx.restore()
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
  toPx,
  toF,
  fromJson,
  parseOrInit,
  initFormData,
  renewFormData,
  getImageUrl,
  reduceLargeImage,
  rotateImage
}
