export async function fetchData(method, url, payload = {}) {
  try {
    const raw = await fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        Accept: 'application/json',
        'Access-Control-Allow-Credentials': true,
        Origin: 'https://globalseguros--ta.sandbox.my.site.com',
        Authentication: `Bearer GEuUKWWjx2b8aGR0GQJJEOWHtkYk`
      },
      body: JSON.stringify(payload),
      Cache: 'default',
      credentials: 'include'
    })

    const response = await raw.json()

    return JSON.stringify(response)
  } catch (error) {
    this.error(error)
  }

  return null
}
