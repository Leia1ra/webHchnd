package com.web.hchnd.service;

import com.web.hchnd.vo.AccountVO;
import com.web.hchnd.vo.ProfileVO;

public interface AccountService {
    public String lastUID(String state);

    public int temporaryAccount(AccountVO vo);

    public int emailCheck(String emailID);
    public int updateAuth(String UID, String tmp);
    public int profileRecord(String UID);
    public AccountVO loginAction(String emailID);
    public int updatePassWord(String pwd, String lastUpdate, String UID);
    public ProfileVO myPageSelect(String UID);
    public int duplicateNickName(String nickName);
    public int myPageUpdate(ProfileVO vo);

}
