import { Controller } from "@hotwired/stimulus";
// import { Html5QrcodeScanner } from "html5-qrcode";

export default class extends Controller {
  static targets = ["reader"]
  connect() {
    console.log("Barcode scanner connected");


    let html5QrcodeScanner = new Html5QrcodeScanner(
      this.readerTarget.id,
      { fps: 10, qrbox: { width: 250, height: 250 } },
      /* verbose= */ true
    );

    html5QrcodeScanner.render(this.onScanSuccess, this.onScanFailure);
  }

  onScanSuccess = (decodedText, decodedResult) => {
    console.log(`Code matched = ${decodedText}`, decodedResult);
  };

  onScanFailure = (error) => {
    console.warn(`Code scan error = ${error}`);
  };
}
