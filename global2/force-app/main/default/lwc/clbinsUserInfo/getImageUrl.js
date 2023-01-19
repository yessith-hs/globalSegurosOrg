export const getImageUrl = (url) => {
  const splitUrl = url.split('/').slice(2).join('/')
  return splitUrl
}
