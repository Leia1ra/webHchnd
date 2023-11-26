package com.web.hchnd.service;

import com.web.hchnd.mapper.CertifyBoardMapper;
import com.web.hchnd.vo.AccountVO;
import com.web.hchnd.vo.CertifyBoardVO;
import com.web.hchnd.vo.HeartVO;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class CertifyBoardServiceImpl implements CertifyBoardService{
    @Inject
    CertifyBoardMapper mapper;

    @Override
    public int certifyBoardWrite(CertifyBoardVO vo) {
        return mapper.certifyBoardWrite(vo);
    }

    @Override
    public void certifyBoardHitCount(int no) {
        mapper.certifyBoardHitCount(no);
    }

    @Override
    public CertifyBoardVO certifyBoardSelect(int no, String category) {
        return mapper.certifyBoardSelect(no, category);
    }

    @Override
    public AccountVO findWriterName(String name) {
        return mapper.findWriterName(name);
    }

    @Override
    public int countHeart(int articleNo, String keyNo) {
        return mapper.countHeart(articleNo, keyNo);
    }

    @Override
    public int heartState(HeartVO vo) {
        return mapper.heartState(vo);
    }

    @Override
    public int heartInsert(HeartVO vo) {
        return mapper.heartInsert(vo);
    }

    @Override
    public int heartDelete(HeartVO vo) {
        return mapper.heartDelete(vo);
    }

    @Override
    public int certifyBoardDelete(int no, String category) {
        return mapper.certifyBoardDelete(no, category);
    }

    @Override
    public int certifyBoardEdit(CertifyBoardVO vo) {
        return mapper.certifyBoardEdit(vo);
    }
}
