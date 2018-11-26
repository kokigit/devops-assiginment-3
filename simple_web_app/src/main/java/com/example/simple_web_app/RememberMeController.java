package com.example.simple_web_app;

import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.simple_web_app.service.LogActivity;
import com.example.simple_web_app.service.LogActivityRepository;

@Controller
public class RememberMeController {

	@Autowired
	private LogActivityRepository logActivityRepository;

	@RequestMapping("/rememberme")
	public ModelAndView hello(Map<String, Object> model) {
		ModelAndView map = new ModelAndView("RememberMe");

		LogActivity loggedactivity = logActivityRepository.findOne(1);
		String lastLoggedTime = "None";
		if(loggedactivity != null) {
			lastLoggedTime = loggedactivity.getLastLoggedTime();
		}
			Date now = new Date();
			LogActivity logActivity = new LogActivity();
			logActivity.setId(1);
			logActivity.setLastLoggedTime(now.toString());
			logActivityRepository.save(logActivity);


		model.put("name", lastLoggedTime);
		return map;
	}
}
