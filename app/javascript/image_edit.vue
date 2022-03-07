<template>
  <div class="form-group">
    <label for="mark_description">description</label>
    <textarea rows="1" class="form-control" id="mark_description" name="mark[description]"></textarea>
  </div>
  <div class="form-group">
    <label for="mark_image">imaggg</label>
    <input class="form-control" @change="setImage" type="file" name="mark[image]" id="mark_image">
  </div>

  <div id="mark-image">
    <p id="preview"></p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      description: '',
      location: '',
      imageFile: null
    };
  },
  methods : {
    setImage(e) {
      e.preventDefault();
      this.preview(e.target)
      this.imageFile = e.target.files[0];
    },
    preview(e) {
      console.log('hohoho');
      let allPreview = document.createElement("div");
      allPreview.setAttribute("id", "mark-image");
      let newPreview = document.createElement("p");
      newPreview.setAttribute("id", "preview");
      allPreview.insertBefore(newPreview, allPreview.firstChild);
      let fileReader = new FileReader();
      fileReader.onload = (function (e) {
        let img = new Image();
        img.src = e.target.result;
        document.getElementById('preview').appendChild(img);
      });
      fileReader.readAsDataURL(e.files[0]);
    }
  }
}
</script>
