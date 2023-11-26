package com.web.hchnd.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor
public class CertifyBoardVO {
    private int no;
    private String UID;
    private String ip;
    private String subject;
    private String content;
    private int hit;
    private String imageName;
    private String writeDate;
    private boolean hidden;
    private String category;

    /*view*/
    private String categoryName;
    /*edit*/
    private String beforeCategory;
}
