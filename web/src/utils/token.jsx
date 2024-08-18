const TOKEN = 'token';
const setUserToken = (token) => {
    localStorage.setItem(token, token)
}

const getUserToken = () => {
    return localStorage.getItem(TOKEN)
}

const removeUserToken = () => {
    localStorage.removeItem(TOKEN)
}

export {
    setUserToken,
    getUserToken,
    removeUserToken
}