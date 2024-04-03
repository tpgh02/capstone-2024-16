package com.dodo.certification.dto;


import com.dodo.certification.domain.Certification;
import com.dodo.certification.domain.CertificationStatus;
import com.dodo.certification.domain.Vote;
import com.dodo.certification.domain.VoteStatus;
import com.dodo.image.domain.Image;
import com.dodo.room.domain.Room;
import lombok.Data;

@Data
public class CertificationDetailResponseData {
    private Image image;
    private Integer voteUp;
    private Integer voteDown;
    private Integer voteUpMax;
    private Integer voteDownMax;
    private CertificationStatus certificationStatus;
    private VoteStatus myVoteStatus;

    public CertificationDetailResponseData(Certification certification, Vote vote, Room room) {
        this.image = certification.getImage();
        this.voteUp = certification.getVoteUp();
        this.voteDown = certification.getVoteDown();
        this.certificationStatus = certification.getStatus();

        this.voteUpMax = room.getNumOfVoteSuccess();
        this.voteDownMax = room.getNumOfVoteFail();

        if(vote == null) this.myVoteStatus = VoteStatus.NONE;
        else this.myVoteStatus = vote.getVoteStatus();
    }
}
