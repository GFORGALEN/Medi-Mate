const TOKEN = 'token';
const setUserToken = (token) => {
    sessionStorage.setItem(token, token)
}

const getUserToken = () => {
    return sessionStorage.getItem(TOKEN)
}

const removeUserToken = () => {
    sessionStorage.removeItem(TOKEN)
}

export {
    setUserToken,
    getUserToken,
    removeUserToken
}