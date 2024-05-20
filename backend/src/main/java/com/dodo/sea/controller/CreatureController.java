package com.dodo.sea.controller;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.exception.NotFoundException;
import com.dodo.sea.dto.CreatureData;
import com.dodo.sea.dto.InventoryCreatureData;
import com.dodo.sea.dto.SeaCreatureData;
import com.dodo.sea.repository.SeaCreatureRepository;
import com.dodo.sea.service.CreatureService;
import com.dodo.user.UserRepository;
import com.dodo.user.domain.User;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/creature")
@Slf4j
public class CreatureController {
    private final CreatureService creatureService;
    private final UserRepository userRepository;


    @PostMapping("/create")
    @ResponseBody
    //@CustomAuthentication
    public CreatureData createCreature(//@RequestAttribute UserContext userContext,
                                       @RequestParam MultipartFile img,
                                       @RequestParam String name,
                                       @RequestParam String info,
                                       @RequestParam Integer price) throws IOException {

        return creatureService.createCreature(name, info, price, img);
    }

    @PostMapping("/purchase")
    @ResponseBody
    @CustomAuthentication
    public Boolean purchase(@RequestAttribute UserContext userContext, @RequestBody CreatureData creatureData) {

        return creatureService.purchaseCreature(userContext, creatureData); // false면 구매 불가, true면 구매 완료.
    }

    @GetMapping("/store")
    public List<CreatureData> store(){

        return creatureService.getAllCreature();
    }

    @GetMapping("/inventory")
    @CustomAuthentication
    public List<InventoryCreatureData> getUserInventory(@RequestAttribute UserContext userContext){
        return creatureService.getUserCreature(userContext);
    }

    // 바다 미리보기에서 저장버튼으로 유저의 바다를 업데이트 하는 postmapping
    @PostMapping("/update-sea")
    public String moveCreature(@RequestBody SeaCreatureData seaCreatureData) {
        creatureService.updateCreature(seaCreatureData);

        return "200 OK";
    }

    // 유저가 바다를 클릭했을 때 보여줄 함수
    @GetMapping("/sea")
    @CustomAuthentication
    public List<SeaCreatureData> displaySea(@RequestAttribute UserContext userContext){
        return creatureService.getSeaCreatures(userContext);
    }

    @PostMapping("/delete")
    @CustomAuthentication
    public String deleteCreature(@RequestAttribute UserContext userContext, @RequestParam Long creatureId){
        creatureService.deleteCreature(userContext, creatureId);

        return "OK";
    }
}
