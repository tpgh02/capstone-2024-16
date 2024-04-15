package com.dodo.sea.controller;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.image.ImageService;
import com.dodo.sea.dto.CreatureData;
import com.dodo.sea.service.CreatureService;
import com.dodo.sea.service.SeaService;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/creature")
public class CreatureController {
    private final SeaService seaService;
    private final ImageService imageService;
    private final CreatureService creatureService;

    @PostMapping("/create")
    @ResponseBody
    @CustomAuthentication
    public CreatureData createCreature(//@RequestAttribute UserContext userContext,
                                       @RequestParam String name,
                                       @RequestParam String info,
                                       @RequestParam Integer price,
                                       @RequestParam MultipartFile img) throws IOException {

        return creatureService.createCreature(name, info, price, img);
    }
}
