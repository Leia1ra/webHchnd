package com.web.hchnd.controller;

import com.web.hchnd.service.AccountService;
import com.web.hchnd.vo.AccountVO;
import com.web.hchnd.vo.ProfileVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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

import javax.inject.Inject;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
@RequestMapping("/account")
public class AccountController {
    @Autowired
    AccountService service;
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;
    @Inject
    JavaMailSenderImpl mailSender;

    /* 회원가입 */
    @GetMapping("/join")
    public String join(){
        return "account/join";
    }

    @PostMapping("/accountCheck")
    @ResponseBody
    public boolean accountCheck(String emailID){
        System.out.print("이메일 검사 : "+emailID);
        int result = service.emailCheck(emailID);
        System.out.println(" > 결과 :"+ result);
        /*메일 중복 검사*/
        if(result == 0){
            return true;
        } else {
            return false;
        }
    }

    @PostMapping("/joinAction")
    public ModelAndView joinAction(AccountVO vo){
        ModelAndView mav = new ModelAndView();
        /*비밀번호 bcrypt 암호화 스레드 1*/
        Thread pwdEncodeThread = new Thread(() -> {
            String encodedPassword = passwordEncoder.encode(vo.getPwd());
            vo.setPwd(encodedPassword);
        });
        /*임시 UID + 메일 인증 키 스레드 2*/
        /*정기적으로 한번씩 DB상에서 지울것 권장하는 로직*/
        Thread uidGenThread = new Thread(() -> {
            String tmp_UID = service.lastUID("Temporary_%");
            if(tmp_UID == null){
                vo.setUID("Temporary_00000");
            } else {
                int lastCount = Integer.parseInt(tmp_UID);
                String toStr = String.format("%05d",++lastCount);
                vo.setUID("Temporary_"+toStr);
            }
        });

        try{ // 스레드 시작(1,2)
            pwdEncodeThread.start();
            uidGenThread.start();
            /*모든 쓰레드 종료시 까지 대기*/
            pwdEncodeThread.join();
            uidGenThread.join();
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
        }


        /*DB Insert 스레드 3*/
        Thread DBInsertResult = new Thread(() -> {
            int result = service.temporaryAccount(vo);
            if(result > 0){ /*성공*/
                mav.setViewName("redirect:logIn");
            } else {        /*실패*/
                mav.setViewName("account/result/joinResult");
            }
        });
        /*메일전송 스레드 4*/
        Thread MailSending = new Thread(() -> {
            String subject = "헬창놈들 가입 확인 메일입니다.";//메일 제목
            String content = "<h1>본 메일은 회원가입을 위한 인증 메일입니다.</h1>" +
                    "<p><a href='http://localhost:8080/hchnd/account/mailCheck?tmp=" + vo.getUID() +"'>회원가입을 진행하시려면 클릭해주세요</a></p>";
            try{
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
                messageHelper.setFrom("iraleia92@gmail.com");//보내는 주소
                messageHelper.setTo(vo.getEmailID());
                messageHelper.setSubject(subject);
                messageHelper.setText("text/html;charset=UTF-8", content);
                mailSender.send(message);
            } catch (MessagingException e) {
                System.out.println(e.getMessage());
            }
        });

        try{ // 스레드 시작(3,4)
            DBInsertResult.start();
            MailSending.start();
            DBInsertResult.join();
            MailSending.join();
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
        }

        return mav;
    }

    /* 메일 인증 확인 */
    @GetMapping("/mailCheck")
    public ModelAndView MailCheck(String tmp){
        ModelAndView mav = new ModelAndView();
        // 현재 날짜를 가져오기
        LocalDate currentDate = LocalDate.now();

        // 날짜를 원하는 형식으로 포맷팅
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        String UID = "R" + currentDate.format(formatter) + "_";


        String lastUID = service.lastUID(UID+"%");
        if(lastUID == null){
            UID = UID + "00000";
        } else {
            int lastCount = Integer.parseInt(lastUID);
            String toStr = String.format("%05d",++lastCount);
            UID = UID + toStr;
        }
        System.out.println(UID);

        int result = service.updateAuth(UID, tmp);
        int profile = service.profileRecord(UID);
        if(result > 0){
            mav.setViewName("redirect:logIn");
        } else {
            mav.setViewName("account/result/joinResult");
        }
        return mav;
    }

    /* 로그인 */
    @GetMapping("/logIn")
    public String login(){
        return "account/logIn";
    }

    @PostMapping("/auth")
    @ResponseBody
    public int loginAuth(String emailID, String pwd, HttpSession session){
        AccountVO vo = service.loginAction(emailID);
        /*암호 평문과 Encoding된 비밀번호의 일치 여부 확인*/
        boolean result = passwordEncoder.matches(pwd, vo.getPwd());
        String validationCheck = vo.getUID().substring(0,10);

        /*비밀번호 만료일*/
        String lastUpdate = vo.getLastUpDate();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expirationDate = LocalDateTime.parse(lastUpdate,DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")).plusMonths(6);

        boolean expirationCheck = now.isAfter(expirationDate);

        if(!expirationCheck && result && !validationCheck.equals("Temporary_")){
            /*로그인 성공*/
            session.setAttribute("logId", vo.getUID());
            session.setAttribute("logName", vo.getNickname());
            session.setAttribute("logEmail", vo.getEmailID());
            session.setAttribute("profileImg", vo.getProfileImgName());
            session.setAttribute("logStatus", "Y");
            return 0;
        } else if(validationCheck.equals("Temporary_")){ /*비인증 계졍*/
            return 1;
        } else if(expirationCheck){ /*계정 비밀번호 기간 만료*/
            /*로그인은 허용 하나 로그인할때마다 뜨게 할거임*/
            session.setAttribute("logId", vo.getUID());
            session.setAttribute("logName", vo.getNickname());
            session.setAttribute("logEmail", vo.getEmailID());
            session.setAttribute("profile", vo.getProfileImgName());
            session.setAttribute("logStatus", "Y");
            return 2;
        } else {
            return 3;
        }
    }

    @PostMapping("/logInAction")
    public ModelAndView logInAction(){
        ModelAndView mav = new ModelAndView();
        mav.setViewName("redirect:/");
        return mav;
    }

    /* 로그아웃 */
    @GetMapping("/logOut")
    public ModelAndView logOutAction(HttpSession session){
        session.invalidate();

        ModelAndView mav = new ModelAndView();
        mav.setViewName("redirect:/");
        return mav;
    }

    /* 비밀번호 변경 */
    @GetMapping("/passWordChange")
    public String passWordChange(){
        return "account/result/passWordChange";
    }
    @PostMapping("/pwValidationCheck")
    @ResponseBody
    public int pwValidationCheck(String nowPwd, String pwd, HttpSession session){
        AccountVO vo = service.loginAction((String) session.getAttribute("logEmail"));
        /*암호 평문과 Encoding된 비밀번호의 일치 여부 확인*/
        boolean result = passwordEncoder.matches(nowPwd, vo.getPwd());
        if(result){
            // LocalDateTime now = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String now = LocalDateTime.now().format(formatter);
            String encodedPassword = passwordEncoder.encode(pwd);
            int updateResult = service.updatePassWord(encodedPassword, now, vo.getUID());
            if(updateResult > 0){
                return 0;
            } else {
                return 1;
            }
        } else {
            return 2;
        }
    }
    @PostMapping("/pwcAction")
    public ModelAndView passWordChangeAction() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("redirect:/");
        return mav;
    }


    /* 마이페이지 */
    @GetMapping("/myPage")
    public ModelAndView myPage(HttpSession session){
        ModelAndView mav = new ModelAndView();
        ProfileVO vo = service.myPageSelect((String) session.getAttribute("logId"));

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDateTime cd = LocalDateTime.parse(vo.getCreateDate(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        vo.setCreateDate(cd.format(formatter));
        mav.addObject("pvo", vo);
        mav.setViewName("account/myPage");
        return mav;
    }
    @GetMapping("/duplicateCheck")
    @ResponseBody
    public boolean nickCheck(String nickName){
        int nickNameCount = service.duplicateNickName(nickName);
        if(nickNameCount == 0){
            return true;
        } else {
            return false;
        }
    }
    @PostMapping("/myPageAction")
    @Transactional(rollbackFor = {RuntimeException.class, SQLException.class})
    public ModelAndView myPageAction(ProfileVO vo, HttpSession session, HttpServletRequest request){
        ModelAndView mav = new ModelAndView();
        /*1. UID*/
        String UID = (String) session.getAttribute("logId");
        vo.setUID(UID);

        /*2. 파일 업로드*/
        // > 파일을 업로드할 위치 폴더 구하기(절대 주소)
        String path = session.getServletContext().getRealPath("/img/userProfile");
        System.out.println("path : " + path);

        // > HttpServletRequest -> MultipartHttpServletRequest 객체를 구한다
        MultipartHttpServletRequest mr = (MultipartHttpServletRequest)request;
        // > MultipartHttpServletRequest 객체 내에 파일 수만큼 MultipartFile 객체가 있음
        MultipartFile profileImg = mr.getFile("profileImg"); // inputTag 의 name속성 값

        if (profileImg != null && !profileImg.isEmpty()){
            // > 기존 프로필 지우기 (확장자 때문)
            if(!vo.getProfileImgName().equals("default_Image.jpg")){
                File beforeImg = new File(path,vo.getProfileImgName());
                beforeImg.delete();
            }

            String originalFilename = profileImg.getOriginalFilename();
            // 파일의 본래 이름이 있어야지만 수행
            if(originalFilename != null && !originalFilename.equals("")){
                String ext = originalFilename.substring(originalFilename.indexOf("."));
                String newProfileName = UID + ext;
                File newImg = new File(path, newProfileName);

                // > 업로드
                try {
                    profileImg.transferTo(newImg);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                vo.setProfileImgName(newProfileName);
            }
        }
        try {
            int result = service.myPageUpdate(vo);
        } catch (Exception e) {
            e.printStackTrace();
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }

        /*세션 값 수정*/
        session.setAttribute("logName", vo.getNickName());
        session.setAttribute("profileImg", vo.getProfileImgName());
        mav.setViewName("redirect:myPage");
        return mav;
    }

    /*DashBoard*/
    @GetMapping("/dashBoard")
    public String dashBoard(){
        return "account/dashBoard";
    }
}