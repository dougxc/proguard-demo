module demo {
    exports com.demo;
    uses com.demo.Service;
    provides com.demo.Service with com.demo.ServiceImpl;
}