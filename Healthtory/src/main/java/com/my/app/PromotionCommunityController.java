package com.my.app;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.control.service.PromotionCommentService;
import com.control.service.PromotionCommunityService;
import com.control.service.PromotionCommentService;
import com.control.vo.PromotionCommunityVO;
import com.control.vo.PromotionCommentVO;
import com.google.gson.Gson;


@Controller
@RequestMapping("/promotioncommunity/*")
public class PromotionCommunityController {
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public void getlist(@RequestParam (value="pg", required=false, defaultValue="1") String pg)throws Exception {
		
	 }
	
	@RequestMapping(value = "/write", method = RequestMethod.GET)
	 public void getwrite() throws Exception {

	 }
	
	@RequestMapping(value = "/writeDB", method = RequestMethod.POST)
	public String getwriteDB(@RequestParam ("title") String title,
			 				@RequestParam ("editordata") String editordata,
			 				@RequestParam ("id") String id,
			 				@RequestParam ("nickname") String nickname,
			 				@RequestParam ("sumnail") String sumnail,
			 				Model model) throws Exception {
		
		PromotionCommunityVO vo = new PromotionCommunityVO();
		if(sumnail.equals("null")){
			sumnail="/resources/image/screencommunity/icon.jpg";
		}
		vo.setTitle(title);
		vo.setText(editordata);
		vo.setId(id);
		vo.setNickname(nickname);
		vo.setSumnail(sumnail);
		
		PromotionCommunityService service = new PromotionCommunityService();
		service.write(vo);
		
		model.addAttribute("title", title);
		model.addAttribute("text",  editordata);		
		model.addAttribute("id",id);
		model.addAttribute("nickname", nickname);
		
		return "promotioncommunity/writeDB";
		
	}
	
	@RequestMapping(value = "/view", method = RequestMethod.GET)
	 public String getview(@RequestParam ("no") String no,Model model) throws Exception {
		PromotionCommunityService service = new PromotionCommunityService();
		service.viewsup(Integer.parseInt(no));
		
		model.addAttribute("no",no);
		
		return "promotioncommunity/view";

	 }
	
	@RequestMapping(value = "/delete", method = RequestMethod.GET)
	 public String getdelete(@RequestParam ("no") String no,Model model) throws Exception {
		PromotionCommunityService service = new PromotionCommunityService();
		service.delete(Integer.parseInt(no));
		
		model.addAttribute("no",no);
		
		return "promotioncommunity/delete";
	 }
	
	@RequestMapping(value = "/comment", method = RequestMethod.GET)
	 public void geComment()throws Exception {
			
	 }
	
	@RequestMapping(value = "/commentDB", method = RequestMethod.GET)
	 public String geCommentDB(
			 @RequestParam ("comment_text") String text,
			 @RequestParam ("id") String id,
			 @RequestParam ("nickname") String nickname,
			 @RequestParam ("no") String no,			 
			 Model model)throws Exception {
		
		 PromotionCommentService service=new PromotionCommentService();
		 PromotionCommentVO vo = new PromotionCommentVO();
		 vo.setText(text);
		 vo.setId(id);
		 vo.setNickname(nickname);
		 vo.setPromotionno(no);
		 service.write(vo);
		 
		 return "/promotioncommunity/commentDB";
			
	 }
	
	@RequestMapping(value="image", produces = "application/json" , method= {RequestMethod.POST})
	@ResponseBody
	 public JSONObject uploadSummernoteImageFile(@RequestParam("file") MultipartFile file) {
		JSONObject jsonObject = new JSONObject();
		Gson gson= new Gson();

		String fileRoot = "C:\\Users\\you\\Desktop\\My_Space\\GitHub\\Healthtory\\Healthtory\\src\\main\\webapp\\resources\\image\\promotioncommunity\\";
		String root="/resources/image/promotioncommunity/";
		String originalFileName = file.getOriginalFilename();	
		String extension = originalFileName.substring(originalFileName.lastIndexOf("."));	
				
		String savedFileName = UUID.randomUUID() + extension;	
		
		File targetFile = new File(fileRoot + savedFileName);	
	
		System.out.println(originalFileName);
		
		try {
			InputStream fileStream = file.getInputStream();
			FileUtils.copyInputStreamToFile(fileStream, targetFile);	
			jsonObject.put("url", root+savedFileName);
			jsonObject.put("responseCode", "success");
			System.out.println(""+jsonObject.get("url"));
			System.out.println("success");
				
		} catch (IOException e) {
			FileUtils.deleteQuietly(targetFile);	
			jsonObject.put("url", "error");
			jsonObject.put("responseCode", "error");
			e.printStackTrace();
		}
		
		return jsonObject;
    }	
}
