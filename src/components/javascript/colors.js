export const colors = {
  teal: "#11cdef",
  black: "#172b4d",
  orange: "#fb6340",
  green: "#2dce89",
  pink: "#f5365c",
  blue: "#5e72e4",
  grey: "#f4f5f7",

  grey1: "#f6f9fc",
  grey2: "#e9ecef",
  grey3: "#dee2e6",
  grey4: "#ced4da",
  grey5: "#adb5bd",
  grey6: "#8898aa",
  grey7: "#525f7f",
  grey8: "#32325d",
  grey9: "#212529"
}

export function shuffled() {
  let array = [
    colors.teal,
    colors.orange,
    colors.green,
    colors.pink,
    colors.blue
  ]

  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));

    [
      array[i],
      array[j]
    ] = [
      array[j],
      array[i]
    ]
  }

  return array
}
