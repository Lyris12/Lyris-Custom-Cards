--機光襲雷－ドーン
function c101010414.initial_effect(c)
--self-destruct
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010414.descon)
	e2:SetOperation(c101010414.desop)
	c:RegisterEffect(e2)
	--protect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c101010414.regop)
	c:RegisterEffect(e0)
	--fetch
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101010414)
	e3:SetTarget(c101010414.tg)
	e3:SetOperation(c101010414.op)
	c:RegisterEffect(e3)
	--destroy & draw During your turn: You can destroy 1 Dragon-Type monster you control or in your hand; draw 1 card. (This is a Quick Effect.)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,101010414)
	e1:SetRange(LOCATION_PZONE+LOCATION_MZONE)
	e1:SetCondition(c101010414.con)
	e1:SetCost(c101010414.dmcost)
	e1:SetTarget(c101010414.dmtg)
	e1:SetOperation(c101010414.dmop)
	c:RegisterEffect(e1)
	if not c101010414.global_check then
		c101010414.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(c101010414.chk)
		Duel.RegisterEffect(ge1,0)
	end
end
c101010414.dm=true
function c101010414.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,300)
	Duel.CreateToken(1-tp,300)
end
function c101010414.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(300)>0 and Duel.GetTurnPlayer()==tp
end
function c101010414.cfilter(c)
	return c:IsSetCard(0x167) and c:IsType(TYPE_MONSTER) and c:IsDestructable() --and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c101010414.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010414.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	local d1=Duel.SelectMatchingCard(tp,c101010414.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Destroy(d1,REASON_COST)
end
function c101010414.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101010414.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101010414.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010414.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101010414.filter(c)
	return c:IsSetCard(0x167) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetCode()~=101010414
end
function c101010414.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010414.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010414.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010414.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101010414.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsReason(REASON_DESTROY) then
		if Duel.GetTurnPlayer()~=tp then
			Duel.Hint(HINT_CARD,0,101010414)
			if Duel.GetAttacker() and not Duel.IsDamageCalculated() then Duel.NegateAttack()
			else
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_ATTACK_ANNOUNCE)
				e1:SetCountLimit(1)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetOperation(c101010414.disop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c101010414.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101010414)
	Duel.NegateAttack()
end
