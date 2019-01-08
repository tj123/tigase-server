package com.example.demo.controller;

import com.example.demo.common.Session;
import com.example.demo.po.TestPo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

@RestController
public class MainController {

    private static final String FILE_PATH = "E://temp";

    @Autowired
    Session session;

    @PostMapping("/")
    public String test(@RequestParam(defaultValue = "Who am I") String userId, @RequestParam ArrayList<String> ids) {
//    这样子接收不到
//    public String test(@RequestParam(defaultValue = "Who am I") String userId,ArrayList<String> ids) {
        System.out.println(userId);
        System.out.println(ids);
        session.setUserId(userId);
        return userId;
    }

    @GetMapping("/session")
    public String session() {
        String userId = session.getUserId();
        System.out.println(userId);
        return userId;
    }

    @PostMapping("/test")
    public TestPo test(TestPo testPo) {
        return testPo;
    }

    @PostMapping("/upload")
    public String file(MultipartFile file, String text) throws IOException {
        System.out.println("text:" + text);
        System.out.println(file);
        Path path = Paths.get(FILE_PATH, file.getOriginalFilename());
        Path parent = path.getParent();
        File parentDir = parent.toFile();
        if (!parentDir.exists()) {
            parentDir.mkdirs();
        }
        Files.write(path, file.getBytes());
        return "sssss";
    }

    @GetMapping("/file")
    public void file(HttpServletResponse response) throws Exception {
        File file = new File(FILE_PATH, "1.png");
        response.setContentType("image/png");
        InputStream inputStream = new FileInputStream(file);
        byte[] cache = new byte[2048];
        int read;
        while (-1 != (read = inputStream.read(cache))) {
            response.getOutputStream().write(cache, 0, read);
        }
    }


}
