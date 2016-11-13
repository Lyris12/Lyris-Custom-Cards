--created by LionHeartKIng
--coded by Lyris
--Sea Scout - Hiro
function c101020013.initial_effect(c)
	--If this card is Normal Summoned: You can Special Summon 1 "Sea Scout" monster from your Deck, except "Sea Scout - Hiro", but you cannot Special Summon monsters for the rest of this turn, except WATER monsters from the Extra Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c101020013.sptg)
	e2:SetOperation(c101020013.spop)
	c:RegisterEffect(e2)
	--Up to twice per turn: You can target 1 "Sea Scout" monster you control; increase or decrease its Level by 1, until the end of this turn.
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetTarget(c101020013.target)
	e1:SetOperation(c101020013.operation)
	c:RegisterEffect(e1)
	--If this card is sent to the Graveyard for the Synchro Summon of a "Sea Scout" Synchro Monster: You can draw 1 card. You can only use this effect of "Sea Scout - Hiro" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101020013)
	e1:SetCondition(c101020013.drcon)
	e1:SetTarget(c101020013.drtg)
	e1:SetOperation(c101020013.drop)
	c:RegisterEffect(e1)
end
function c101020013.spfilter(c,e,tp)
	return c:IsSetCard(0x5cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetCode()~=101020013
end
function c101020013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101020013.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101020013.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101020013.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e0:SetTargetRange(1,0)
		e0:SetTarget(c101020013.splimit)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
	end
end
function c101020013.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_EXTRA))
end
function c101020013.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5cd) and c:IsLevelAbove(1)
end
function c101020013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101020013.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101020013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(101020013,1))
	else op=Duel.SelectOption(tp,aux.Stringid(101020013,1),aux.Stringid(101020013,2)) end
	e:SetLabel(op)
end
function c101020013.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
function c101020013.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0x5cd)
end
function c101020013.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101020013.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
