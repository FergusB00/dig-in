import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["ingredient", "weight", "unit", "manualForm"]
  static values = {
    api: String
  }

  connect() {
    console.log("Connected from barcode controller")
    this.selectedDeviceId = null;
    this.codeReader = new ZXing.BrowserMultiFormatReader()
    console.log('ZXing code reader initialized')
    console.log(this.apiValue)
    // console.dir(Object.entries(this.ingredientTarget.options))
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
        this.getBarcodeData(result)
        this.codeReader.reset()
        this.toggleManualForm()
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

  toggleManualForm() {
    this.manualFormTarget.classList.toggle("d-none");
  }

  getBarcodeData(result) {
    const barcode = result.text
    const apiKey = this.apiValue;
    console.log(apiKey)
    const url = `/barcode_lookup?barcode=${result.text}`;
    fetch(url)
      .then(response => response.json())
      .then((data) => {
        const ingredientName = data.products[0].title;
        console.log(ingredientName);

        const size = data.products[0].size;
        const sizeFormat = /(\d+)\s*([a-zA-Z]+)/;
        const match = size.match(sizeFormat);
        const ingredientWeight = match[1];
        const ingredientUnit = match[2];

        console.log(ingredientWeight)
        console.log(ingredientUnit)

        this.ingredientTarget.value = ingredientName;
        this.weightTarget.value = ingredientWeight;
        this.unitTarget.value = ingredientUnit;
    })
  }


  // .catch((err) => {
  //   console.error(err)
  // })

}
