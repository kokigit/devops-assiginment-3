package com.example.simple_web_app.service;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
@Entity
@Table(name = "log_activity")
public class LogActivity {

	private Integer id;
	private String lastLoggedTime;

	@Id
	 @Column( unique = true, nullable = false)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getLastLoggedTime() {
		return lastLoggedTime;
	}
	public void setLastLoggedTime(String lastLoggedTime) {
		this.lastLoggedTime = lastLoggedTime;
	}


}
