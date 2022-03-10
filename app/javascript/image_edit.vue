<template>
  <div id="app">
    <p>投稿フォーム</p>
    <form v-on:submit.prevent="markItem()">
      <p>
        <label>Description</label>
        <input name="mark.description" type="text" v-model="mark.description">
      </p>
      <p>
        <label>Location</label>
        <input name="mark.location" type="text" v-model="mark.location">
      </p>
      <p>
        <label>画像</label>
        <input name="uploadedImage" type="file" ref="file" @change="onFileChange">
      </p>
      <input type="submit" value="Submit">
    </form>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      mark: {},
      uploadedImage: '',
      id: '',
      description: '',
      // location: '',
      // imageFile: null
    }
  },
  methods : {
    // setImage(e) {
    //   e.preventDefault();
    //   this.preview(e.target)
    //   this.imageFile = e.target.files[0];
    // },
    // preview(e) {
    //   console.log('hohoho');
    //   let allPreview = document.createElement("div");
    //   allPreview.setAttribute("id", "mark-image");
    //   let newPreview = document.createElement("p");
    //   newPreview.setAttribute("id", "preview");
    //   allPreview.insertBefore(newPreview, allPreview.firstChild);
    //   let fileReader = new FileReader();
    //   fileReader.onload = (function (e) {
    //     let img = new Image();
    //     img.src = e.target.result;
    //     document.getElementById('preview').appendChild(img);
    //   });
    //   fileReader.readAsDataURL(e.files[0]);
    // },
    onFileChange(event) {
      let file = event.target.files[0] || event.dataTransfer.files
      let reader = new FileReader()
      reader.onload = (e) => {
        this.uploadedImage = e.target.result
        this.mark.image = this.uploadedImage
      }
      reader.readAsDataURL(file)
    },
    markItem() {
      return new Promise((resolve, _) => {
        axios.defaults.headers.common = {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }

        axios({
          url: `/api/marks/${22}`,
          data: {
            mark: this.mark
          },
          method: 'PUT'
        }).then(res => {
          this.mark = {}
          this.uploadedImage = ''
          this.$refs.file.value = ''
          resolve(res)
        }).catch(e => {
          console.log(e)
        })
      })
    }
  }
}
</script>
