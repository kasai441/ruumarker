<template>
  <section>
    <div id="edit-field"
         @pointermove="touchmove($event)"
         @pointerup="touchend($event)"
         @pointerleave="touchend($event)"
         class="my-16 edit-size">
      <img :src="imageUrl" id="edit-image" draggable="false"
           @pointerdown="touchstart($event)"
           class="absolute z-10 edit-size object-contain">
      <div class="relative">
        <div class="absolute z-30 edit-size pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
        <div class="absolute z-20 edit-size pointer-events-none bg-transparent outline outline-240 outline-slate-200 opacity-40"></div>
      </div>
    </div>
  </section>
</template>
<script>

export default {
  name: 'ImageEdit',
  props: [
    'formData',
    'imageFile',
    'imageUrl'
  ],
  data() {
    return {
      trimming: null,
      expansion: 1,
      isMovable: false,
      editFieldLeft: 0,
      editFieldTop: 0,
      editImage: null,
      editImageLeft: 0,
      editImageTop: 0,
      shiftX: 0,
      shiftY: 0,
      editFilterWidth: 0,
      editFilterHeight: 0
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      this.shiftX = Math.floor(e.clientX) - this.editImageLeft
      this.shiftY = Math.floor(e.clientY) - this.editImageTop
    },
    touchmove(e) {
      if (!this.isMovable) return
      const x = Math.floor(e.pageX * this.expansion)
      const y = Math.floor(e.pageY * this.expansion)
      this.editImageLeft = x - this.shiftX
      this.editImageTop = y - this.shiftY
      this.editImage.style.left = this.editImageLeft + 'px'
      this.editImage.style.top = this.editImageTop + 'px'
    },
    touchend(e) {
      this.isMovable = false
      const trimmingX = this.editImageLeft - this.editFieldLeft - this.editFilterWidth
      const trimmingY = this.editImageTop - this.editFieldTop - this.editFilterHeight
      const trimming = JSON.stringify({ x: trimmingX, y: trimmingY })
      this.formData.append('map[trimming]', trimming)
      e.preventDefault()
    }
  },
  created() {
    const trimming = this.formData.get('map[trimming]')
    try {
      this.trimming = JSON.parse(trimming)
    } catch {
      this.trimming = {x: 0, y: 0}
    }
  },
  mounted() {
    if (this.imageFile) {
      const uploadedTag = document.getElementById( 'edit-image' )
      console.log('image_edit:')
      console.log(document.getElementById( 'edit-image' ))
      const reader = new FileReader()
      reader.onload = function () {
        uploadedTag.src = this.result
      }
      console.log(this.imageFile)
      reader.readAsDataURL(this.imageFile)
    } else {
      // this.imageUrl = this.formData.get('map[image_url]')
    }

    const editField = document.getElementById('edit-field')
    this.editFieldLeft = Math.floor(editField.getBoundingClientRect().left)
    this.editFieldTop = Math.floor(editField.getBoundingClientRect().top)

    let editImageLeft = this.editFieldLeft
    let editImageTop =  this.editFieldTop
    if (this.trimming !== null && typeof(this.trimming) === 'object') {
      editImageLeft = this.editFieldLeft + this.editFilterWidth + this.trimming.x
      editImageTop = this.editFieldTop + this.editFilterHeight + this.trimming.y
    }

    this.editImage = document.getElementById('edit-image')
    this.editImage.style.left = editImageLeft + 'px'
    this.editImage.style.top = editImageTop + 'px'
    this.editImageLeft = Math.floor(this.editImage.getBoundingClientRect().left)
    this.editImageTop = Math.floor(this.editImage.getBoundingClientRect().top)
  },
  updated() {
    this.$emit('emitFormData', this.formData)
  }
}
</script>
