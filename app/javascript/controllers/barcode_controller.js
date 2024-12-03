import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Connected from barcode controller")
    this.selectedDeviceId = null;
    this.codeReader = new ZXing.BrowserMultiFormatReader()
    console.log('ZXing code reader initialized')
  }


  captureCode() {
    this.codeReader.listVideoInputDevices()
    .then((videoInputDevices) => {
      this.selectedDeviceId = videoInputDevices[0].deviceId
      console.log('Using video device')
    this.codeReader.decodeFromVideoDevice(this.selectedDeviceId, 'video', (result, err) => {
      console.log('Capture recording')
      if (result) {
        console.log(result)
        this.codeReader.reset()
      }
      if (err && !(err instanceof ZXing.NotFoundException)) {
        console.error(err)
      }
    })
  })
  }

  resetButton() {
    this.codeReader.reset();
    console.log("Barcode reader reset");
  }

  // .catch((err) => {
  //   console.error(err)
  // })

}
