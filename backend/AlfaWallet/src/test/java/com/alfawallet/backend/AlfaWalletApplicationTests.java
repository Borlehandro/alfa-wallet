package com.alfawallet.backend;

import com.alfawallet.backend.yandex.YandexApiController;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class AlfaWalletApplicationTests {

	@Autowired
	YandexApiController controller;

	@Test
	void contextLoads() {
		var res = controller.searchByLocationAndCardName(
				"Быстроном",
				"54.859222",
				"83.109696"
		);
		Assertions.assertFalse(res.getFeatures().isEmpty());
	}

}
