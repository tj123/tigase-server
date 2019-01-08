package com.example.demo.po;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;

@Setter
@Getter
@ToString
public class TestPo {

    private String guid;

    private String id;

    private ArrayList<String> ids;

    private String names;

    private Long timestamp;

}
