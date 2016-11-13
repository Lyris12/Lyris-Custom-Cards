--created by Hiro
--coded by Lyris
--Flame Flight - Perch
function c101020104.initial_effect(c)
	c:SetUniqueOnField(1,0,101020104)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_TOGRAVE+TIMING_REMOVE)
	e1:SetCondition(c101020104.condition)
	e1:SetTarget(c101020104.target)
	e1:SetOperation(c101020104.op)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101020104.con)
	e2:SetCost(c101020104.cost)
	e2:SetTarget(c101020104.tg)
	e2:SetOperation(c101020104.op)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c101020104.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa88)
end
function c101020104.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE then return true end
	local res1,teg1,tep1,tev1,tre1,tr1,trp1=Duel.CheckEvent(EVENT_TO_GRAVE,true)
	local res2,teg2,tep2,tev2,tre2,tr2,trp2=Duel.CheckEvent(EVENT_REMOVE,true)
	return ((res1 and teg1:IsExists(c101020104.filter,1,nil)) or (res2 and teg2:IsExists(c101020104.filter,1,nil)))
end
function c101020104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local res1,teg1,tep1,tev1,tre1,tr1,trp1=Duel.CheckEvent(EVENT_TO_GRAVE,true)
	local res2,teg2,tep2,tev2,tre2,tr2,trp2=Duel.CheckEvent(EVENT_REMOVE,true)
	if Duel.GetCurrentPhase()==PHASE_DAMAGE
		or (res1 and teg1:IsExists(c101020104.filter,1,nil)) or (res2 and teg2:IsExists(c101020104.filter,1,nil)) then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.RegisterFlagEffect(tp,101020104+,RESET_PHASE+PHASE_END,0,1)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		e:SetLabel(1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function c101020104.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101020104.filter,1,nil)
end
function c101020104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101020104.==0 end
	Duel.RegisterFlagEffect(tp,101020104+,RESET_PHASE+PHASE_END,0,1)
end
function c101020104.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101020104.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
