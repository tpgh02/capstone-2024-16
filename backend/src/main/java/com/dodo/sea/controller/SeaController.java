package com.dodo.sea.controller;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.sea.dto.CreatureData;
import com.dodo.sea.service.SeaService;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/sea")
public class SeaController {
    private final SeaService seaService;

    @PostMapping("/purchase")
    @ResponseBody
    @CustomAuthentication
    public Boolean purchase(@RequestAttribute UserContext userContext, CreatureData creatureData) {

        return seaService.purchaseCreature(userContext, creatureData); // false면 구매 불가, true면 구매 완료.
    }

}
