--Dragluo Samurai
function c101020027.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--You cannot Pendulum Summon monsters, except Dragon-Type monsters. This effect cannot be negated.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(aux.nfbdncon)
	e1:SetTarget(c101020027.splimit)
	c:RegisterEffect(e1)
	--If this card is Pendulum Summoned, its Level becomes 8 until the end of this turn, but its controller cannot Special Summon monsters for the rest of the turn, except Dragon-Type monsters.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c101020027.con)
	e4:SetOperation(c101020027.op)
	c:RegisterEffect(e4)
	--If this card is sent to the Graveyard: You can add 1 "Dragluo" monster from your Deck to your hand, except "Dragluo Samurai". You can only use this effect of "Dragluo Samurai" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101020027)
	e2:SetTarget(c101020027.thtg)
	e2:SetOperation(c101020027.thop)
	c:RegisterEffect(e2)
	--A Dragon-Type Xyz Monster that was Summoned using this card as Xyz Material gains this effect. (effect below)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c101020027.efcon)
	e3:SetOperation(c101020027.efop)
	c:RegisterEffect(e2)
end
function c101020027.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_DRAGON) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101020027.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101020027.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
	e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e0:SetValue(8)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101020027.sumlimit)
	Duel.RegisterEffect(e1,c:GetControler())
end
function c101020027.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_DRAGON
end
function c101020027.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x94b) and c:IsAbleToHand() and c:GetCode()~=101020027
end
function c101020027.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020027.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101020027.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101020027.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101020027.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c101020027.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsRace(RACE_DRAGON) then return end
	--If it is Xyz Summoned: You can target 1 Spell/Trap Card your opponent controls; destroy that target.
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(101020027,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101020027.drcon)
	e1:SetTarget(c101020027.drtg)
	e1:SetOperation(c101020027.drop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c101020027.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c101020027.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c101020027.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c101020027.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020027.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101020027.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101020027.drop(e)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
