import { Controller } from "@hotwired/stimulus";
import { BrowserQRCodeReader } from '@zxing/library';
// import { BrowserQRCodeReader } from '@zxing/browser';

export default class extends Controller {
  static targets = ["reader"]
  connect() {
    console.log("Barcode scanner connected");

    this.codeReader = new BrowserQRCodeReader();

      // console.log()
      // codeReader.listVideoInputDevices().then(videoInputResult => {
      //   console.log(videoInputResult[0].deviceId);
        // result is video input device
      this.codeReader.decodeFromVideoDevice(undefined, 'video')
        .then(result => {
          console.log(result);


    })

    console.log(this.codeReader);

      // })

    // const videoInputDevices = ZXingBrowser.BrowserCodeReader.listVideoInputDevices();
    // const videoInputDevices = new ZXingBrowser.BrowserCodeReader.listVideoInputDevices();

    // choose your media device (webcam, frontal camera, back camera, etc.)
    // const selectedDeviceId = videoInputDevices[0].deviceId;

    // console.log(`Started decode from camera with id ${selectedDeviceId}`);

    // const previewElem = document.querySelector('#test-area-qr-code-webcam > video');

    // you can use the controls to stop() the scan or switchTorch() if available
    // const controls = codeReader.decodeFromVideoDevice(undefined, 'video')
    // .then(result => {
    //   console.log(result);

    // })
    // => {
    //   // use the result and error values to choose your actions
    //   // you can also use controls API in this scope like the controls
    //   // returned from the method.
    // });

    // stops scanning after 20 seconds
    // setTimeout(() => controls.stop(), 20000);

    // const onScanSuccess = (decodedText, decodedResult) => {
    //   // handle the scanned code as you like, for example:
    //   console.log(`Code matched = ${decodedText}`, decodedResult);
    // }

    // const onScanFailure = (error) => {
    //   // handle scan failure, usually better to ignore and keep scanning.
    //   // for example:
    //   console.warn(`Code scan error = ${error}`);
    // }


    // let html5QrcodeScanner = new Html5QrcodeScanner(
    //   this.readerTarget.id,
    //   { fps: 1, qrbox: {width: 250, height: 250} },
    //     /* verbose= */ true
    //   );

    // html5QrcodeScanner.render(onScanSuccess, onScanFailure);
  }
}
