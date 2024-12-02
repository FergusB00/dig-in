import { Controller } from "@hotwired/stimulus";
import { Html5QrcodeScanner } from "html5-qrcode";

export default class extends Controller {
  static targets = ["reader"]
  connect() {
    console.log("Barcode scanner connected");

    const onScanSuccess = (decodedText, decodedResult) => {
      // handle the scanned code as you like, for example:
      console.log(`Code matched = ${decodedText}`, decodedResult);
    }

    const onScanFailure = (error) => {
      // handle scan failure, usually better to ignore and keep scanning.
      // for example:
      console.warn(`Code scan error = ${error}`);
    }


    let html5QrcodeScanner = new Html5QrcodeScanner(
      this.readerTarget.id,
      { fps: 1, qrbox: {width: 250, height: 250} },
        /* verbose= */ true
      );

    html5QrcodeScanner.render(onScanSuccess, onScanFailure);
  }

  // onScanSuccess(decodedText, decodedResult) {
  //   console.log(`Code matched = ${decodedText}`, decodedResult);
  // };

  // onScanFailure(error) {
  //   console.warn(`Code scan error = ${error}`);
  // };
}
