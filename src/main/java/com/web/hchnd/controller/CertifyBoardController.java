package com.web.hchnd.controller;

import com.web.hchnd.service.CertifyBoardService;
import com.web.hchnd.vo.AccountVO;
import com.web.hchnd.vo.CertifyBoardVO;
import com.web.hchnd.vo.HeartVO;
import com.web.hchnd.vo.PagingVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller @RequestMapping("/community")
public class CertifyBoardController {
    @Autowired
    CertifyBoardService service;

    @GetMapping("/certifyWrite")
    public String test(){
        return "community/certifyBoardWrite";
    }

    @PostMapping("/certifyOk")
    @Transactional(rollbackFor = {RuntimeException.class, SQLException.class})
    public ModelAndView certifyOk(CertifyBoardVO vo, HttpSession session, HttpServletRequest request){
        ModelAndView mav = new ModelAndView();
        /*1. UID*/
        String UID = (String) session.getAttribute("logId");
        vo.setUID(UID);
        vo.setIp(request.getRemoteAddr());

        /*2. 파일 업로드*/
        // > 파일을 업로드할 위치 폴더 구하기(절대 주소)
        String path = session.getServletContext().getRealPath("/img/certifyBoard");
        System.out.println("path : " + path);

        // > HttpServletRequest -> MultipartHttpServletRequest 객체를 구한다
        MultipartHttpServletRequest mr = (MultipartHttpServletRequest)request;
        // > MultipartHttpServletRequest 객체 내에 파일 수만큼 MultipartFile 객체가 있음
        MultipartFile profileImg = mr.getFile("certifyImg"); // inputTag 의 name속성 값

        if (profileImg != null && !profileImg.isEmpty()){
            String originalFilename = profileImg.getOriginalFilename();
            // 파일의 본래 이름이 있어야지만 수행
            if(originalFilename != null && !originalFilename.equals("")){
                String ext = originalFilename.substring(originalFilename.indexOf("."));
                String newProfileName = UID + "(0)" + ext;
                File newImg = new File(path, newProfileName);
                if(newImg.exists()){
                    for(int renameNum = 1; ; renameNum++){
                        newProfileName = UID + "(" + renameNum + ")" + ext;
                        newImg = new File(path, newProfileName);
                        if(!newImg.exists()){
                            break;
                        }
                    }
                }

                // > 업로드
                try {
                    profileImg.transferTo(newImg);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                vo.setImageName(newProfileName);
            }
        }
        try {
            int result = service.certifyBoardWrite(vo);
            if(result > 0){
                mav.setViewName("redirect:list");
            } else {
                mav.addObject("msg", "등록");
                mav.setViewName("/board/boardResult");
            }
        } catch (Exception e) {
            e.printStackTrace();
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return mav;
    }

    @GetMapping("/certifyView")
    public ModelAndView certifyView(int no, String category, PagingVO pVO){
        service.certifyBoardHitCount(no);

        ModelAndView mav = new ModelAndView();
        CertifyBoardVO vo = service.certifyBoardSelect(no, category);
        AccountVO writer = service.findWriterName(vo.getUID());

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDateTime cd = LocalDateTime.parse(vo.getWriteDate(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        vo.setWriteDate(cd.format(formatter));

        mav.addObject("vo",vo);
        mav.addObject("writer", writer);
        mav.addObject("pVO",pVO);
        mav.setViewName("community/certifyBoardView");
        return mav;
    }
    @GetMapping("/heartCount")
    @ResponseBody
    public int heartCount(int articleNo, String keyNo){
        return service.countHeart(articleNo, keyNo);
    }
    @PostMapping("/heartState")
    @ResponseBody
    public boolean heartState(HeartVO vo){
        int interaction = service.heartState(vo);
        System.out.println(interaction);
        if(interaction == 0){
            return true;
        } else {
            return false;
        }
    }

    @PostMapping("/heart")
    @ResponseBody
    public boolean heart(HeartVO vo){
        int interaction = service.heartState(vo);

        if(interaction == 0){
            service.heartInsert(vo);
            return true;
        } else {
            service.heartDelete(vo);
            return false;
        }
    }


    @GetMapping("/certifyDelete")
    public ModelAndView certifyDelete(int no, String category, String imageName, HttpSession session){
        ModelAndView mav = new ModelAndView();
        int result = service.certifyBoardDelete(no, category);
        if(result > 0){
            String path = session.getServletContext().getRealPath("/img/certifyBoard");
            System.out.println("path : " + path);
            File f = new File(path, imageName);
            if(f.exists()){
                f.delete();
            }
            mav.setViewName("redirect:list");
        } else {
            mav.setViewName("redirect:certifyView?no="+no+"&category="+category);
        }
        return mav;
    }
    @GetMapping("/certifyEdit")
    public ModelAndView certifyEdit(int no, String category){
        ModelAndView mav = new ModelAndView();

        mav.addObject("vo", service.certifyBoardSelect(no,category));
        mav.setViewName("community/certifyBoardEdit");
        return mav;
    }


    @PostMapping("/certifyEditOk")
    @Transactional(rollbackFor = {RuntimeException.class, SQLException.class})
    public ModelAndView certifyEditOk(CertifyBoardVO vo, HttpSession session, HttpServletRequest request){
        ModelAndView mav = new ModelAndView();
        System.out.println(vo.toString());
        /*1. UID*/
        String UID = (String) session.getAttribute("logId");
        vo.setUID(UID);
        vo.setIp(request.getRemoteAddr());

        /*2. 파일 업로드*/
        // > 파일을 업로드할 위치 폴더 구하기(절대 주소)
        String path = session.getServletContext().getRealPath("/img/certifyBoard");
        System.out.println("path : " + path);

        // > HttpServletRequest -> MultipartHttpServletRequest 객체를 구한다
        MultipartHttpServletRequest mr = (MultipartHttpServletRequest)request;
        // > MultipartHttpServletRequest 객체 내에 파일 수만큼 MultipartFile 객체가 있음
        MultipartFile profileImg = mr.getFile("certifyImg"); // inputTag 의 name속성 값

        if (profileImg != null && !profileImg.isEmpty()){
            String originalFilename = profileImg.getOriginalFilename();
            // 파일의 본래 이름이 있어야지만 수행
            if(originalFilename != null && !originalFilename.equals("")){
                File oldImg = new File(path, vo.getImageName());
                System.out.println(vo.getImageName());
                if(oldImg.exists()){
                    oldImg.delete();
                }

                String ext = originalFilename.substring(originalFilename.indexOf("."));
                String newProfileName = UID + "(0)" + ext;
                File newImg = new File(path, newProfileName);
                if(newImg.exists()){
                    for(int renameNum = 1; ; renameNum++){
                        newProfileName = UID + "(" + renameNum + ")" + ext;
                        newImg = new File(path, newProfileName);
                        if(!newImg.exists()){
                            break;
                        }
                    }
                }

                // > 업로드
                try {
                    profileImg.transferTo(newImg);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                vo.setImageName(newProfileName);
            }
        }
        try {
            int result = service.certifyBoardEdit(vo);
            System.out.println(result);
            if(result > 0){
                mav.setViewName("redirect:list");
            } else {
                mav.addObject("msg", "등록");
                mav.setViewName("/account/boardResult");
            }
        } catch (Exception e) {
            e.printStackTrace();
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return mav;
    }
}
