package blog;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity

public class Email {
	@Id Long id;
	private String address;
	
	private Email() {}
	
	public Email(String initAddress) {
		address = initAddress;
	}
	
	public String getAddress() {
		return address;
	}
	
	public void setAddress(String newAddress) {
		address = newAddress;
	}
}
