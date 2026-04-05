import { Controller } from "@hotwired/stimulus"
import * as L from "leaflet"

const DEFAULT_TILE_URL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
const DEFAULT_ATTRIBUTION = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
const FALLBACK_CLASSES = [ "flex", "items-center", "justify-center", "p-6", "text-center", "text-sm", "text-stone-500" ]

export default class extends Controller {
  static values = {
    markers: Array,
    tileUrl: String,
    attribution: String,
    zoom: Number
  }

  connect() {
    if (!this.hasMarkersValue || this.markersValue.length === 0) {
      this.renderFallback("Map data will appear once coordinates are available.")
      return
    }

    try {
      this.renderMap()
    } catch (error) {
      console.error("Leaflet map failed to render", error)
      this.renderFallback("Map unavailable right now.")
    }
  }

  disconnect() {
    this.teardownMap()
  }

  renderMap() {
    this.teardownMap()
    this.clearFallback()
    this.element.textContent = ""

    const markers = this.markersValue
    const firstMarker = markers[0]

    this.map = L.map(this.element, {
      attributionControl: true,
      zoomControl: true
    })

    L.tileLayer(this.tileUrlValue || DEFAULT_TILE_URL, {
      attribution: this.attributionValue || DEFAULT_ATTRIBUTION,
      maxZoom: 19
    }).addTo(this.map)

    const bounds = L.latLngBounds()

    markers.forEach((markerData) => {
      const marker = L.marker([ markerData.lat, markerData.lng ], {
        title: markerData.title
      }).addTo(this.map)

      bounds.extend(marker.getLatLng())

      const popupContent = this.buildInfoWindowContent(markerData)
      if (popupContent) {
        marker.bindPopup(popupContent)
      }
    })

    if (markers.length > 1) {
      this.map.fitBounds(bounds, { padding: [ 60, 60 ] })
    } else {
      this.map.setView([ firstMarker.lat, firstMarker.lng ], this.zoomValue || 5)
    }
  }

  renderFallback(message) {
    this.teardownMap()
    this.element.textContent = ""
    this.element.classList.add(...FALLBACK_CLASSES)
    this.element.textContent = message
  }

  buildInfoWindowContent(markerData) {
    if (!markerData.title && !markerData.info) return null

    const container = document.createElement("div")
    container.style.fontFamily = "IBM Plex Sans, sans-serif"
    container.style.padding = "4px 6px"

    if (markerData.title) {
      const title = document.createElement("strong")
      title.textContent = markerData.title
      container.appendChild(title)
    }

    if (markerData.info) {
      if (container.childNodes.length > 0) {
        container.appendChild(document.createElement("br"))
      }

      const info = document.createElement("span")
      info.textContent = markerData.info
      container.appendChild(info)
    }

    return container
  }

  clearFallback() {
    this.element.classList.remove(...FALLBACK_CLASSES)
  }

  teardownMap() {
    if (this.map) {
      this.map.remove()
      this.map = null
    }
  }
}
