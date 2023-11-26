package com.web.hchnd.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor
public class ProfileVO {
    /*user*/
    private String UID;
    private String nickName;
    private String emailID;
    private String createDate;
    /*profile*/
    private String profileImgName;
    private int age;
    private int gender;
    private double height;
    private double weight;
    private double bfm;
    private double skm;
}
