package com.web.hchnd.service;

import com.web.hchnd.vo.AccountVO;
import com.web.hchnd.vo.CertifyBoardVO;
import com.web.hchnd.vo.HeartVO;

public interface CertifyBoardService {
    public int certifyBoardWrite(CertifyBoardVO vo);
    public void certifyBoardHitCount(int no);
    public CertifyBoardVO certifyBoardSelect(int no, String category);
    public AccountVO findWriterName(String name);
    public int countHeart(int articleNo, String keyNo);
    public int heartState(HeartVO vo);
    public int heartInsert(HeartVO vo);
    public int heartDelete(HeartVO vo);

    public int certifyBoardDelete(int no, String category);
    public int certifyBoardEdit(CertifyBoardVO vo);


}
