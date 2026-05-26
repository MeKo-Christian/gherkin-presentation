#import "@preview/polylux:0.4.0": *
#import "@preview/tiaoma:0.3.0"
#import "@preview/pinit:0.2.2": *
#import "lib/gherkin-syntax/lib.typ": cucumber-syntax
#import "lib/monochrome-theme/lib.typ": monochrome-theme

#let meko_green = rgb(0, 136, 133)
#let meko_grey = rgb("#4b4c53")
#let meko_body = rgb("#595959")

#let meko-slide-background() = {
  // Border frame shifted far bottom-left so only the top-right corner is visible
  place(
    bottom + left,
    dx: -768pt,
    dy: 495pt,
    image("../assets/border-frame.png", width: 960pt, height: 540pt),
  )
  // Corner decoration bottom-right
  place(
    bottom + right,
    dx: 768pt,
    dy: 495pt,
    image("../assets/border-frame.png", width: 960pt, height: 540pt),
  )
  // MeKo.de logo bottom-left
  place(
    bottom + left,
    dx: 30pt,
    dy: -15pt,
    image("../assets/meko-logo.png", height: 12pt),
  )
}

#let setup(body) = {
  set page(
    paper: "presentation-16-9",
    margin: (left: 60pt, right: 60pt, top: 40pt, bottom: 50pt),
    footer: {
      h(1fr)
      set text(size: 12pt, fill: meko_grey)
      toolbox.slide-number
    },
    footer-descent: 25pt,
    background: meko-slide-background(),
  )

  set text(
    font: (
      "Calibri",
      "Fira Sans",
      "Noto Sans",
    ),
    size: 18pt,
    weight: "light",
    fill: meko_body,
  )

  // Setup code highlighting
  show raw: set text(font: "Fira Mono", size: 14pt)
  show: cucumber-syntax
  show raw: it => {
    show regex("pin\d+"): it => pin(eval(it.text.slice(3)))
    it
  }

  // show: monochrome-theme

  show emph: set text(fill: meko_green)

  show heading: set text(font: ("Proxima Nova Rg", "Proxima Nova"))
  show heading.where(level: 1): set text(size: 23pt, fill: meko_green, weight: "bold")
  // show heading.where(level: 1): set block(spacing: 30pt)

  show heading.where(level: 2): set text(fill: meko_grey)
  show heading.where(level: 3): set text(fill: meko_grey, size: 20pt)

  show strong: set text(fill: meko_grey)

  set list(marker: text(fill: meko_green, sym.bullet), indent: 1em)

  show link: set text(fill: meko_green)
  show link: content => underline(content)

  body
}

#let content-slide(title, body) = slide[
  === #title

  #align(horizon)[
    #body
  ]
]

#let title-slide(
  title: [],
  subtitle: [],
  authors: [],
  extra: [],
  url: none,
  title-image: none,
) = slide[
  #set page(footer: none)
  // Background image
  #place(top + left, dx: -60pt, dy: -40pt,
    image("../assets/title-bg.jpeg", width: 100% + 120pt, height: 100% + 90pt),
  )
  // Overlay with stent imagery
  #place(top + left, dx: -60pt, dy: -40pt,
    image("../assets/title-overlay.png", width: 100% + 120pt, height: 100% + 90pt),
  )
  // White MeKo Medtech logo top-right
  #place(top + right, dx: 30pt, dy: -30pt,
    image("../assets/white-logo.png", width: 250pt),
  )
  #set text(fill: white)
  #show heading.where(level: 1): set text(fill: white, size: 32pt, font: "Proxima Nova Rg", weight: "bold")
  #show link: set text(fill: white)

  #place(left + top, dx: 10%, dy: 50%)[
    #block(width: 60%)[
      = #title
      #v(30pt, weak: true)
      #text(size: 20pt)[#subtitle]
      #if authors != [] {
        v(50pt, weak: true)
        set text(style: "italic")
        authors
      }
      #if extra != [] {
        v(10pt, weak: true)
        extra
      }
    ]
  ]

  #if url != none {
    place(bottom + left, dy: -20pt)[
      #grid(
        columns: (auto, 1fr),
        gutter: 1em,
        align: horizon,
        tiaoma.barcode(
          url,
          "QRCode",
          options: (fg-color: white, bg-color: none),
        ),
        {
          set text(size: 14pt)
          link(url)
        },
      )
    ]
  }
]

#let section-slide(title, body) = slide[
  // Section background image
  #place(top + left, dx: -60pt, dy: -40pt,
    image("../assets/section-bg.jpeg", width: 100% + 120pt, height: 100% + 90pt),
  )
  #set text(fill: white)
  #show heading.where(level: 2): set text(size: 30pt, fill: white)
  #show heading.where(level: 2): set block(spacing: 2em)
  #toolbox.register-section(title)
  #align(center + horizon)[
    == #title

    #body
  ]
]

#let item-by-item(start: 1, mode: hide, body) = {
  let is-item(it) = (
    type(it) == content
      and it.func()
        in (
          list.item,
          enum.item,
          terms.item,
        )
  )

  let children = if type(body) == content and body.has("children") {
    body.children
  } else {
    body
  }

  let children = children.filter(is-item)

  for i in range(children.len()) {
    only(
      start + i,
      list(..for j in range(i + 1) { (children.at(j).body,) }),
    )
  }
}
