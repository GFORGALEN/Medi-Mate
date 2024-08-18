import {
    AppstoreOutlined,
    ContainerOutlined,
    DesktopOutlined,
    MailOutlined,
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
        key: '2',
        icon: <DesktopOutlined/>,
        label: 'Products',
    },
    {
        key: '3',
        icon: <ContainerOutlined/>,
        label: 'Option 3',
    },
    {
        key: 'sub1',
        label: 'Navigation One',
        icon: <MailOutlined/>,
        children: [
            {
                key: '5',
                label: 'Option 5',
            },
            {
                key: '6',
                label: 'Option 6',
            },
            {
                key: '7',
                label: 'Option 7',
            },
            {
                key: '8',
                label: 'Option 8',
            },
        ],
    },
    {
        key: 'sub2',
        label: 'Navigation Two',
        icon: <AppstoreOutlined/>,
        children: [
            {
                key: '9',
                label: 'Option 9',
            },
            {
                key: '10',
                label: 'Option 10',
            },
            {
                key: 'sub3',
                label: 'Submenu',
                children: [
                    {
                        key: '11',
                        label: 'Option 11',
                    },
                    {
                        key: '12',
                        label: 'Option 12',
                    },
                ],
            },
        ],
    },
];
const App = () => {
    const navigate = useNavigate();
    const clickHandler = (e) => {
        navigate(e.key, {replace: true})
    }
    return (
        <div
            style={{
                width: '100%',
                backgroundColor: 'transparent'
            }}
        >
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