import useLogin from "@/hook/useLogin.jsx";
import {SmileOutlined} from '@ant-design/icons';
import {notification} from "antd";
import {useEffect} from 'react';

const Login = () => {
    const {
        email, setEmail,
        password, setPassword,
        error,
        isLoading,
        handleSubmit
    } = useLogin();

    const [api, contextHolder] = notification.useNotification();

    const openNotification = (message) => {
        api.open({
            message: 'Login Error',
            description: message,
            icon: (
                <SmileOutlined
                    style={{
                        color: '#f5222d',
                    }}
                />
            ),
        });
    };

    useEffect(() => {
        if (error) {
            openNotification(error);
        }
    }, [error]);

    return (
        <div className="min-h-screen flex items-center justify-center bg-gray-100">
            <div className="w-full max-w-md bg-white shadow-md rounded-lg p-8">
                <h2 className="text-2xl text-gray-800 text-center mb-6">Sign In</h2>
                <form onSubmit={handleSubmit} className="space-y-6">
                    <div>
                        <label htmlFor="email" className="block text-gray-700 font-medium mb-2">
                            Email
                        </label>
                        <input
                            type="email"
                            id="email"
                            className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="Enter your email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                        />
                    </div>
                    <div>
                        <label htmlFor="password" className="block text-gray-700 font-medium mb-2">
                            Password
                        </label>
                        <input
                            type="password"
                            id="password"
                            className="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="Enter your password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                        />
                    </div>
                    <div className="flex items-center justify-between">
                        <div className="flex items-center">
                            <input
                                type="checkbox"
                                id="remember"
                                className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                            />
                            <label htmlFor="remember" className="ml-2 block text-sm text-gray-900">
                                Remember me
                            </label>
                        </div>
                        <a href="#" className="text-sm text-blue-600 hover:underline">
                            Forgot your password?
                        </a>
                    </div>
                    <button
                        type="submit"
                        className="w-full py-3 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
                        disabled={isLoading}
                    >
                        Sign In
                    </button>
                </form>
            </div>
            {contextHolder}
        </div>
    );
};

export default Login;
