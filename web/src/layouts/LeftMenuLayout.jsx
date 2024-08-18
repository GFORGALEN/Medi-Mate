import {
    DesktopOutlined,
    PieChartOutlined,
} from '@ant-design/icons';
import {Menu} from 'antd';
import {useNavigate} from "react-router-dom";

const items = [
    {
        key: '/analytics',
        icon: <PieChartOutlined/>,
        label: 'Analytics',
    },
    {
        key: '/products',
        icon: <DesktopOutlined/>,
        label: 'Products',
    }
];
const App = () => {
    const navigate = useNavigate();
    const clickHandler = (e) => {
        navigate(e.key, {replace: true})
    }
    return (
        <div>
            <Menu
                defaultSelectedKeys={['1']}
                defaultOpenKeys={['sub1']}
                mode="inline"
                items={items}
                onClick={clickHandler}
            />
        </div>
    );
};
export default App;