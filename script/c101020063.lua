--created & coded by Hiro
--Aggecko Sierra
function c101020063.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(101020063,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,101020063)
	e1:SetCondition(c101020063.condition)
	e1:SetCost(c101020063.cost)
	e1:SetOperation(c101020063.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101020063.sctg)
	e2:SetOperation(c101020063.scop)
	c:RegisterEffect(e2)
	--xyz effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c101020063.xyzcon)
	e3:SetTarget(c101020063.xyztg)
	e3:SetOperation(c101020063.xyzop)
	c:RegisterEffect(e3)
--  --special summon
--  local e4=Effect.CreateEffect(c)
--  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
--  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
--  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
--  e4:SetCode(EVENT_BATTLE_DESTROYING)
--  e4:SetCountLimit(1)
--  e4:SetCondition(c101020063.spcon)
--  e4:SetCost(c101020063.spcost)
--  e4:SetTarget(c101020063.sptg)
--  e4:SetOperation(c101020063.spop)
--  c:RegisterEffect(e4)
end
function c101020063.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (d~=nil and a:GetControler()==tp and a:IsSetCard(0x6d6) and a:IsRelateToBattle())
		or (d~=nil and d:GetControler()==tp and d:IsFaceup() and d:IsSetCard(0x6d6) and d:IsRelateToBattle())
end
function c101020063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101020063.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	if a:GetControler()==tp then
		e1:SetValue(d:GetLevel()*300)
		a:RegisterEffect(e1)
	else
		e1:SetValue(a:GetLevel()*300)
		d:RegisterEffect(e1)
	end
end
function c101020063.filter(c)
	return c:IsSetCard(0x6d6) and c:IsAbleToHand()
end
function c101020063.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020063.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101020063.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101020063.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101020063.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c101020063.mfilter(c)
	return c:IsRace(RACE_REPTILE)
end
function c101020063.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c101020063.xyzfilter2(c,mg,ct)
	return c:IsXyzSummonable(mg) and c.xyz_count==ct
end
function c101020063.mfilter1(c,exg)
	return exg:IsExists(c101020063.mfilter2,1,nil,c)
end
function c101020063.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c101020063.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c101020063.mfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return mg:GetCount()>0 and Duel.IsExistingMatchingCard(c101020063.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c101020063.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	local extc=exg:GetFirst()
	local minct=99
	local maxct=0
	while extc do
		if extc.xyz_count<minct then
			minct=extc.xyz_count
		end
		if extc.xyz_count>maxct then
			maxct=extc.xyz_count
		end
		extc=exg:GetNext()
	end
	local g=mg:Filter(c101020063.mfilter1,nil,exg)
	local mgt=Group.CreateGroup()
	local ct=0
	while not exg:IsExists(c101020063.xyzfilter2,1,nil,mgt,ct) do
		mgt=g:Select(tp,minct,maxct,nil)
		ct=mgt:GetCount()
	end
	Duel.SetTargetCard(mgt)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101020063.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local xyzg=Duel.GetMatchingGroup(c101020063.xyzfilter2,tp,LOCATION_EXTRA,0,nil,g,g:GetCount())
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
--function c101020063.spcon(e,tp,eg,ep,ev,re,r,rp)
--  local c=e:GetHandler()
--  local bc=c:GetBattleTarget()
--  return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
--end
--function c101020063.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
--  Duel.SendtoGrave(e:GetHandler(),REASON_COST)
--end
--function c101020063.spfilter2(c,e,tp)
--  return c:IsSetCard(0x6d6) and not c:IsCode(101020063) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
--end
--function c101020063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
--	  and Duel.IsExistingMatchingCard(c101020063.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
--  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
--end
--function c101020063.spop(e,tp,eg,ep,ev,re,r,rp)
--  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
--  local g=Duel.SelectMatchingCard(tp,c101020063.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
--  if g:GetCount()>0 then
--	  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
--  end
--end
