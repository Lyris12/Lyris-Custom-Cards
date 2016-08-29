--Blitzkrieg Mekdragon Ni
function c101020118.initial_effect(c)
	--If a "Blitzkrieg" monster(s) you control was destroyed by a card effect (except during the Damage Step): You can Special Summon this card from your hand.
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c101020118.spcon)
	e5:SetTarget(c101020118.sptg)
	e5:SetOperation(c101020118.spop)
	c:RegisterEffect(e5)
	--Cannot attack.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e6)
	--If this card is targeted for an attack: Destroy this card.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c101020118.destg)
	e1:SetOperation(c101020118.desop)
	c:RegisterEffect(e1)
	--If this card is destroyed by a card effect and sent to the Graveyard: You can target 1 face-up monster on the field; return that target to the hand. You can only use this effect of "Blitzkrieg Mekdragon Ni" once per turn.
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetCountLimit(1,101020118)
	e0:SetCondition(c101020118.condition)
	e0:SetTarget(c101020118.target)
	e0:SetOperation(c101020118.operation)
	c:RegisterEffect(e0)
end
function c101020118.spcfil(c,tp)
	return c:IsSetCard(0x167) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c101020118.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c101020118.spcfil,1,nil,tp)
end
function c101020118.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101020118.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c101020118.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c101020118.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c101020118.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41
end
function c101020118.filter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c101020118.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101020118.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020118.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101020118.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101020118.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
