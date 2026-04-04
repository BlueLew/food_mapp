import { Controller } from "@hotwired/stimulus"

let googleMapsPromise

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    zoom: Number
  }

  connect() {
    if (!this.hasMarkersValue || this.markersValue.length === 0) {
      this.renderFallback("Map data will appear once coordinates are available.")
      return
    }

    if (!this.apiKeyValue) {
      this.renderFallback("Set GOOGLE_MAPS_API_KEY to enable maps.")
      return
    }

    this.loadGoogleMaps().then(() => this.renderMap())
  }

  async loadGoogleMaps() {
    if (window.google?.maps) return
    if (!googleMapsPromise) {
      googleMapsPromise = new Promise((resolve, reject) => {
        const script = document.createElement("script")
        script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}`
        script.async = true
        script.defer = true
        script.onload = resolve
        script.onerror = reject
        document.head.appendChild(script)
      })
    }
    await googleMapsPromise
  }

  renderMap() {
    const markers = this.markersValue
    const firstMarker = markers[0]

    this.map = new google.maps.Map(this.element, {
      center: { lat: firstMarker.lat, lng: firstMarker.lng },
      zoom: this.zoomValue || 5,
      mapTypeControl: false,
      streetViewControl: false,
      fullscreenControl: false
    })

    const bounds = new google.maps.LatLngBounds()
    const infoWindow = new google.maps.InfoWindow()

    markers.forEach((markerData) => {
      const marker = new google.maps.Marker({
        position: { lat: markerData.lat, lng: markerData.lng },
        map: this.map,
        title: markerData.title
      })

      bounds.extend(marker.position)

      if (markerData.info) {
        marker.addListener("click", () => {
          infoWindow.setContent(`<div style="font-family: IBM Plex Sans, sans-serif; padding: 4px 6px;"><strong>${markerData.title || ""}</strong><br>${markerData.info}</div>`)
          infoWindow.open(this.map, marker)
        })
      }
    })

    if (markers.length > 1) {
      this.map.fitBounds(bounds, 60)
    }
  }

  renderFallback(message) {
    this.element.classList.add("flex", "items-center", "justify-center", "p-6", "text-center", "text-sm", "text-stone-500")
    this.element.textContent = message
  }
}
