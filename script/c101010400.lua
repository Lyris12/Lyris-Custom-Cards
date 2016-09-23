--Dimension-Magica Darknova
function c101010400.initial_effect(c)
    --Additional Effects Here
    if not c101010400.global_check then
        c101010400.global_check=true
        local ge2=Effect.CreateEffect(c)
        ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge2:SetCode(EVENT_ADJUST)
        ge2:SetCountLimit(1)
        ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
        ge2:SetOperation(c101010400.check)
        Duel.RegisterEffect(ge2,0)
    end
end
c101010400.spatial=true
c101010400.alterf=  function(mc)
                        return mc.spatial
                    end
c101010400.alterct=2
c101010400.alterop= function(e,tp,chk)
                        local rc=e:GetLabelObject()
                        if chk==0 then return rc:IsExists(c101010400.alfilter,1,nil,rc) end
                        local mc=Duel.SelectMatchingCard(tp,c101010400.altfilter,tp,LOCATION_MZONE,0,1,1,rc:GetFirst(),rc:GetFirst():GetRace(),rc:GetFirst():GetAttribute())
                        return mc:GetFirst()
                    end
function c101010400.check(e,tp,eg,ep,ev,re,r,rp)
    Duel.CreateToken(tp,500)
    Duel.CreateToken(1-tp,500)
end
function c101010400.alfilter(c,g)
    return c:IsFaceup() and c101010400.alterf(c) and c:IsAbleToRemove() and g:IsExists(c101010400.altfilter,1,c,c:GetRace(),c:GetAttribute())
end
function c101010400.altfilter(c,rc,at)
    return c:IsFaceup() and c:GetRace()==rc and c:GetAttribute()==at and c:IsAbleToRemove()
end