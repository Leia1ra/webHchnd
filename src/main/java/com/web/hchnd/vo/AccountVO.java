package com.web.hchnd.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @AllArgsConstructor @NoArgsConstructor
public class AccountVO {
    private String UID;
    private String nickname;
    private String emailID;
    private String pwd;
    private String createDate;
    private String lastUpDate;

    /*로그인시 프로필 이미지 헤더에 띄우기 위함*/
    private String profileImgName;
}
